{ pkgs
, ...
}:
let
  # this one should be passed
  workspaceCount = 10;

  workspaceBinds = builtins.concatLists (builtins.genList
    (
      x:
      let
        key = builtins.toString (x);
        # key 0 is at the end of the keyboard row
        workspaceNumber = if x == 0 then 10 else x;
      in
      [
        "$mod, ${key}, split-workspace, ${toString workspaceNumber}"
        "$mod SHIFT, ${key}, split-movetoworkspace, ${toString workspaceNumber}"
      ]
    )
    workspaceCount);

in
{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    "$terminal" = "kitty";
    "$menu" = "rofi -show drun";
    "$lock" = "pgrep hyprlock || hyprlock";

    # bind[flag]
    # [flags]
    # l -> locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
    # r -> release, will trigger on release of a key.
    # e -> repeat, will repeat when held.
    # n -> non-consuming, key/mouse events will be passed to the active window in addition to triggering the dispatcher.
    # m -> mouse, see below.
    # t -> transparent, cannot be shadowed by other binds.
    # i -> ignore mods, will ignore modifiers.
    # s -> separate, will arbitrarily combine keys between each mod/key, see [Keysym combos](#keysym-combos) above.
    # d -> has description, will allow you to write a description for your bind.
    # p -> bypasses the app's requests to inhibit keybinds.

    bind = workspaceBinds ++ [
      # basics
      "$mod, SPACE, exec, $menu"
      "$mod, Q, killactive"
      "$mod, L, exec, $lock"
      "$mod, F4, exit,"

      # window actions
      "$mod, T, togglefloating"
      "$mod SHIFT, T, resizewindowpixel, exact 50% 50%,activewindow"
      "$mod, M, fullscreen, 1"
      "$mod, F, fullscreen, 0"

      # window movement
      "$mod SHIFT, COMMA, split-changemonitor, prev"
      "$mod SHIFT, PERIOD, split-changemonitor, next"

      # application shortcuts
      "$mod, W, exec, firefox -P honzakostejn"
      "$mod SHIFT, W, exec, firefox -P NETWORG"
      "$mod, C, exec, code"

      # screenshots
      "$mod, R, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
      "$mod SHIFT, R, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f - -o - | ${pkgs.wl-clipboard}/bin/wl-copy"
    ];
    bindm = [
      "$mod, CONTROL_L, movewindow"
      "$mod, ALT_L, resizewindow"
    ];
    bindl = [
      ", switch:Lid Switch, exec, $lock"
    ];
    bindlei = [
      ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
      ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
      ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
      ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
    ];
    bindli = [
      ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute"
      ", XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute"
      ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
      ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
      ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      ", XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop"
    ];
  };
}