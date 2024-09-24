{
  pkgs,
  ...
}: let
  workspaceConfiguration = builtins.genList (
    x: let
      # genList is zero-indexed, so we need to add 1 to the index
      workspaceNumber = x + 1;
    in
      "${toString workspaceNumber},monitor:Virtual-1,persistent:true"
  ) 10;

  workspaceBinds = builtins.concatLists (builtins.genList (
    x: let
      key = builtins.toString (x);
      # key 0 is at the end of the keyboard row
      workspaceNumber = if x == 0 then 10 else x;
    in [
      "$mod, ${key}, workspace, ${toString workspaceNumber}"
      "$mod SHIFT, ${key}, movetoworkspace, ${toString workspaceNumber}"
    ]
  ) 10);

in {
  # home.file = {
  #   # wallpaper
  #   ".local/share/swww/wallpaper.jpg".source =
  #     "${wallpaper}";
  # };

  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";
    "$menu" = "rofi -show drun";

    "$mod" = "SUPER";
    env = [
      # "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      # "HYPRCURSOR_THEME,${cursorName}"
      # "HYPRCURSOR_SIZE,${toString pointer.size}"
    ];

    monitor = [
      "Virtual-1, 1920x1200@59.88Hz, 0x0, 1"
      "eDP-1, preferred, auto, 1.175000"
      ", preferred, auto, 1"
    ];

    input = {
      accel_profile = "adaptive";
      sensitivity = 0.5;
      touchpad = {
        natural_scroll = true;
        scroll_factor = 0.5;

        # button presses with 1, 2, or 3 fingers will be
        # mapped to LMB, RMB, and MMB respectively
        clickfinger_behavior = true;
        # require physical click
        tap-to-click = false;
      };
    };

    exec-once = [
      # lock the screen, because the greetd is auto-logging the user
      # "hyprlock"
      "hyprctl dispatch workspace 1"
    ];

    workspace = workspaceConfiguration;

    bind = [
      "$mod, Q, killactive"
      "$mod, T, togglefloating"
      "$mod, M, fullscreen, 1"
      "$mod, F, fullscreen, 0"
      "$mod, R, exec, $menu"
      "$mod, F4, exit,"
    ] ++ workspaceBinds;

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
    bindei = [
      ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
      ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
      ",XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
      ",XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
    ];
    bindi = [
      ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute"
      ",XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute"
      ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
      ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
      ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      ",XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop"
    ];
  };
}