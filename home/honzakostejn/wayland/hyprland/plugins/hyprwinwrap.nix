{ inputs
, pkgs
, lib
, config
, ...
}: {
  options = {
    koshos.home.honzakostejn.wayland.hyprland.plugins.hyprwinwrap = {
      enable = lib.mkEnableOption "Hyprwinwrap plugin" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.wayland.hyprland.plugins.hyprwinwrap.enable {
    wayland.windowManager.hyprland.plugins = [
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprwinwrap
    ];

    wayland.windowManager.hyprland.settings = {
      plugin = {
        hyprwinwrap = {
          # class is an EXACT match and NOT a regex!
          class = "terminal-bg";
        };
      };
    };
  };
}
