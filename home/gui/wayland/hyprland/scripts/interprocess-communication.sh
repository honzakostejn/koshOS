#!/bin/sh

handle() {
  case $1 in
    bell*) pw-play "$HOME/.config/hypr/notification.mp3" ;;
  esac
}

socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done