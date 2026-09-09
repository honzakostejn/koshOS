"""Feed the Hyprland cursor into shader-desk's pointer socket.

shader-desk does not listen for pointer events itself: a background daemon
pushes a fixed 24 byte binary datagram over a UNIX datagram socket, and the
"Evdev Pointer Provider" plugin inside the engine drops it onto the blackboard.
Upstream ships an evdev daemon for that, which needs membership in the `input`
group and only ever reports raw hardware deltas.

Hyprland already knows exactly where the cursor is, so this daemon polls its
IPC socket instead and reports absolute, monitor normalised coordinates. That
keeps `/dev/input` out of the picture and additionally populates `mouse.x` /
`mouse.y` on the blackboard, which the evdev daemon only ever fills for
touchscreens and drawing tablets.

Mouse buttons are not part of the Hyprland IPC surface. Hyprland pushes those
to us instead, as `1` / `0` datagrams on our own control socket -- see the
non-consuming binds in the home-manager module.
"""

import argparse
import errno
import json
import os
import selectors
import signal
import socket
import struct
import sys
import time

# daemons/evdev-daemon/pointer-data.hpp: magic, 4 floats, 4 bytes, packed.
POINTER_MAGIC = 0x50545233
POINTER_DATAGRAM = struct.Struct("<I4f4B")

# sun_path is 108 bytes wide; shader-desk falls back to /tmp when a socket
# under XDG_RUNTIME_DIR would not fit into it (src/ipc-utils.hpp).
SUN_PATH_MAX = 108

running = True


def stop(_signum, _frame):
    global running
    running = False


def log(message):
    sys.stderr.write("[hyprland-cursor] {}\n".format(message))
    sys.stderr.flush()


def ipc_socket_path(name):
    """Resolve a path the way shader_desk::get_ipc_socket_path does."""
    runtime = os.environ.get("XDG_RUNTIME_DIR")
    if runtime:
        preferred = os.path.join(runtime, name + ".sock")
        if len(preferred) < SUN_PATH_MAX:
            return preferred
    return "/tmp/{}-{}.sock".format(name, os.getuid())


def hyprland_socket_path():
    signature = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    if not signature:
        sys.exit("HYPRLAND_INSTANCE_SIGNATURE is unset - no Hyprland session")

    candidates = []
    runtime = os.environ.get("XDG_RUNTIME_DIR")
    if runtime:
        candidates.append(
            os.path.join(runtime, "hypr", signature, ".socket.sock"))
    candidates.append(os.path.join("/tmp/hypr", signature, ".socket.sock"))

    for candidate in candidates:
        if os.path.exists(candidate):
            return candidate
    return candidates[0]


def hyprland_request(path, command):
    """Run one request; Hyprland's IPC socket answers and hangs up."""
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
        sock.settimeout(1.0)
        sock.connect(path)
        sock.sendall(command.encode())
        chunks = []
        while True:
            chunk = sock.recv(65536)
            if not chunk:
                break
            chunks.append(chunk)
    return json.loads(b"".join(chunks))


def logical_rects(monitors):
    """Turn `hyprctl monitors` into the layout rectangles the cursor lives in.

    Cursor positions are reported in the compositor's logical coordinate space,
    while a monitor reports its mode in physical pixels, so the mode has to be
    divided by the fractional scale. Odd transforms are the rotated ones, which
    swap the two axes.
    """
    rects = []
    for monitor in monitors:
        if monitor.get("disabled"):
            continue
        scale = monitor.get("scale") or 1.0
        width = monitor["width"] / scale
        height = monitor["height"] / scale
        if monitor.get("transform", 0) % 2:
            width, height = height, width
        if width <= 0 or height <= 0:
            continue
        rects.append((
            monitor.get("name", "?"),
            float(monitor["x"]),
            float(monitor["y"]),
            width,
            height,
        ))
    return rects


def locate(rects, x, y):
    """Normalise a global cursor position against the monitor holding it."""
    for name, left, top, width, height in rects:
        if left <= x < left + width and top <= y < top + height:
            return name, (x - left) / width, (y - top) / height
    return None, 0.0, 0.0


def open_control_socket(path):
    """Bind the socket Hyprland's mouse binds report button state on."""
    try:
        os.unlink(path)
    except FileNotFoundError:
        pass
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
    sock.bind(path)
    sock.setblocking(False)
    return sock


def drain_control(sock, button):
    while True:
        try:
            token = sock.recv(64).strip().lower()
        except BlockingIOError:
            return button
        except OSError:
            return button
        if token in (b"1", b"press", b"down"):
            button = 1
        elif token in (b"0", b"release", b"up"):
            button = 0


def send(sock, path, abs_x, abs_y, rel_dx, rel_dy, button):
    payload = POINTER_DATAGRAM.pack(
        POINTER_MAGIC, abs_x, abs_y, rel_dx, rel_dy,
        1,  # is_absolute: we report a real position, not hardware mickeys
        button,
        0,  # is_touching: capacitive touchpads only, which we cannot see
        0,  # padding
    )
    try:
        sock.sendto(payload, path)
    except OSError as exc:
        # Fire and forget: the engine may not have bound its socket yet, or its
        # receive queue may be full because it is busy rendering a frame.
        if exc.errno not in (errno.ENOENT, errno.ECONNREFUSED,
                             errno.EAGAIN, errno.EWOULDBLOCK):
            raise


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rate", type=float, default=60.0,
                        help="cursor polls per second (default: 60)")
    parser.add_argument("--monitor-refresh", type=float, default=2.0,
                        help="seconds between layout refreshes (default: 2)")
    parser.add_argument("--pointer-socket", default=None,
                        help="shader-desk pointer socket to feed")
    parser.add_argument("--control-socket", default=None,
                        help="socket to receive mouse button state on")
    args = parser.parse_args()

    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)

    hyprland = hyprland_socket_path()
    pointer_path = (args.pointer_socket
                    or ipc_socket_path("shader-desk-pointer"))
    control_path = (args.control_socket
                    or ipc_socket_path("shader-desk-cursor"))
    interval = 1.0 / max(args.rate, 1.0)

    pointer = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
    pointer.setblocking(False)
    control = open_control_socket(control_path)

    selector = selectors.DefaultSelector()
    selector.register(control, selectors.EVENT_READ)

    log("hyprland={} pointer={} control={}".format(
        hyprland, pointer_path, control_path))

    rects = []
    refreshed_at = 0.0
    complained_at = 0.0
    monitor = None
    last_x = None
    last_y = None
    button = 0
    last_button = None

    while running:
        # Wakes early when Hyprland reports a button, otherwise paces the poll.
        for _ in selector.select(timeout=interval):
            button = drain_control(control, button)

        now = time.monotonic()
        try:
            if now - refreshed_at >= args.monitor_refresh:
                rects = logical_rects(hyprland_request(hyprland, "j/monitors"))
                refreshed_at = now
            position = hyprland_request(hyprland, "j/cursorpos")
        except (OSError, ValueError) as exc:
            # Hyprland restarted or is mid-reload; keep the layout and retry.
            if now - complained_at >= 10.0:
                log("hyprland query failed: {}".format(exc))
                complained_at = now
            time.sleep(interval)
            continue

        name, abs_x, abs_y = locate(rects, position["x"], position["y"])
        if name is None:
            continue

        if name == monitor and last_x is not None:
            rel_dx = abs_x - last_x
            rel_dy = abs_y - last_y
        else:
            # A fresh monitor gives no meaningful delta; a jump across the
            # layout would otherwise yank every scene that integrates them.
            rel_dx = 0.0
            rel_dy = 0.0

        # The provider keeps the last value it was handed, so an idle cursor
        # needs no traffic at all - only actual changes go over the wire.
        if abs_x != last_x or abs_y != last_y or button != last_button:
            send(pointer, pointer_path, abs_x, abs_y, rel_dx, rel_dy, button)

        monitor = name
        last_x = abs_x
        last_y = abs_y
        last_button = button

    selector.close()
    control.close()
    pointer.close()
    try:
        os.unlink(control_path)
    except OSError:
        pass


if __name__ == "__main__":
    main()
