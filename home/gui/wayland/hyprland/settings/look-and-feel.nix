{ ... }: {
  wayland.windowManager.hyprland.settings = {
    config = {
      general = {
        layout = "dwindle";
        border_size = 4;
        "col.active_border" = "rgba(808080aa)";
        "col.inactive_border" = "rgba(ffffff00)";
        gaps_in = 0;
        gaps_out = 8;
      };

      decoration = {
        active_opacity = 1.00;
        inactive_opacity = 1.00;
        fullscreen_opacity = 1.00;
        rounding = 10;
        blur = {
          enabled = false;
          size = 8;
          passes = 2;
          new_optimizations = true;
          xray = true;
        };
      };

      animations.enabled = false;
    };

    # bezier = [
    #   { _args = [ "wind"   0.02    0.9   0.1  1.03 ]; }
    #   { _args = [ "winIn"  0.1     1.1   0.1  1.1  ]; }
    #   { _args = [ "winOut" 0.2   (-0.2)  0    1    ]; }
    #   { _args = [ "liner"  1       1     1    1    ]; }
    # ];

    # animation = [
    #   { _args = [ "windows"     1  6  "wind"   "slide" ]; }
    #   { _args = [ "windowsIn"   1 12  "winIn"  "popin" ]; }
    #   { _args = [ "windowsOut"  1 12  "winOut" "popin" ]; }
    #   { _args = [ "windowsMove" 1  5  "wind"   "slide" ]; }
    #   { _args = [ "fade"        1 10  "default"        ]; }
    #   { _args = [ "workspaces"  1 20  "wind"           ]; }
    # ];
  };
}
