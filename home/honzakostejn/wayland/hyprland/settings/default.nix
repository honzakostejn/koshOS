{ inputs
, pkgs
, config
, ...
}: {
  imports = [
    ./binds.nix
    ./look-and-feel.nix
  ];

  wayland.windowManager.hyprland.settings = {
    env = [
      # "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      # "HYPRCURSOR_THEME,${cursorName}"
      # "HYPRCURSOR_SIZE,${toString pointer.size}"
    ];

    monitor = [
      # shikane is used for dynamic display management
      "eDP-1, preferred, auto, 1.33"
      ", preferred, auto, 1"
      # "DP-1, preferred, auto, 1, mirror, eDP-1"
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
      "${config.programs.ags.finalPackage}/bin/ags run"
      # "${pkgs.hyprpanel}/bin/hyprpanel"
      # "hyprctl dispatch split-workspace 1"
    ];

    misc = {
      disable_splash_rendering = true;
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      background_color = "0x00000000";
      animate_manual_resizes = true;
    };
  };
}
