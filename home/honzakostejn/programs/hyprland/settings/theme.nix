{ ...
}: {
  wayland.windowManager.hyprland.settings = {
    decoration = {
      rounding = 16;
      drop_shadow = true;
      shadow_range = 8;
      shadow_render_power = 2;
      "col.shadow" = "rgba(1a1a1aa6)";
      dim_special = 0.0;


      blur = {
        enabled = true;
        size = 2;
        passes = 3;
        new_optimizations = true;
        xray = false;
        contrast = 0.7;
        brightness = 0.5;
        noise = 0.4;
        vibrancy = 80;
        vibrancy_darkness = 0.0;
        special = true;
      };
    };

    general = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      layout = "dwindle";
      gaps_in = 8;
      gaps_out = 16;
      border_size = 2;
      "col.active_border" = "rgba(A89984de)";
      "col.inactive_border" = "rgba(A8998480)";
    };

    animations = {
      # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
      enabled = true;
      bezier = [
        "wind, 0.02, 0.9, 0.1, 1.03"
        "winIn, 0.1, 1.1, 0.1, 1.1"
        "winOut, 0.2, -0.2, 0, 1"
        "liner, 1, 1, 1, 1"
      ];
      animation = [
        "windows, 1, 6, wind, slide"
        "windowsIn, 1, 12, winIn, popin"
        "windowsOut, 1, 12, winOut, popin"
        "windowsMove, 1, 5, wind, slide"
        "fade, 1, 10, default"
        "workspaces, 1, 20, wind"
      ];
    };
  };
}
