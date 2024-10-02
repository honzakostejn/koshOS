{ pkgs
, ...
}: {
  imports = [
    ./binds.nix
    ./theme.nix
  ];

  wayland.windowManager.hyprland.settings = {
    env = [
      # "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      # "HYPRCURSOR_THEME,${cursorName}"
      # "HYPRCURSOR_SIZE,${toString pointer.size}"
    ];

    monitor = [
      "eDP-1, preferred, auto, 1.175000"
      ", preferred, auto, 1"
    ];

    input = {
      kb_layout = "us,cz";
      kb_variant = ",qwerty";
      kb_options = "grp:alt_shift_toggle";

      follow_mouse = 2;
      accel_profile = "adaptive";
      sensitivity = 0.5;

      touchpad = {
        # scrolling settings
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
      "${pkgs.shikane}/bin/shikane"
      "hyprctl dispatch split-workspace 1"
    ];

    general = {
      layout = "dwindle";
      border_size = 4;
      "col.active_border" = "rgba(A8C5E6ff) rgba(f1a7e2ff) 45deg";
      "col.inactive_border" = "0x000B0A10";
      gaps_in = 8;
      gaps_out = 15;
    };

    misc = {
      disable_splash_rendering = true;
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      animate_manual_resizes = true;
    };
  };
}
