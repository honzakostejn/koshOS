{ inputs
, pkgs
, ...
}: {
  wayland.windowManager.hyprland.plugins = [
    inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
  ];

  wayland.windowManager.hyprland.settings = {
    plugin = {
      hyprwinwrap = {
        # class is an EXACT match and NOT a regex!
        class = "terminal-bg";
      };
    };
  };
}
