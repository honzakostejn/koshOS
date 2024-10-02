{ ...
}: {
  wayland.windowManager.hyprland.settings = {
    decoration = {
      rounding = 16;
      drop_shadow = 1;
      shadow_range = 15;
      shadow_render_power = 2;
      shadow_ignore_window = 1;
      shadow_offset = "0 4";
      "col.shadow" = "0x55000000";
      "col.shadow_inactive" = "0x55000000";

      blur = {
        enabled = true;
        size = 8;
        passes = 2;
        new_optimizations = true;
        xray = true;
        # contrast = 0.7;
        # brightness = 0.5;
        # noise = 0.4;
        # vibrancy = 80;
        # vibrancy_darkness = 0.0;
        # special = true;
      };
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
