{ lib
, config
, inputs
, pkgs
, ...
}:
let
  # cursor = "Bibata-Modern-Classic-Hyprcursor";
  # cursorPackage = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.bibata-hyprcursor;

in
{
  options = {
    koshos.home.honzakostejn.programs.hyprland = {
      enable = lib.mkEnableOption "Hyprland window manager" // { default = true; };
    };
  };

  imports = [
    inputs.hyprland.homeManagerModules.default

    ./settings
    ./plugins

    # ./hyprpaper.nix
  ];

  config = lib.mkIf config.koshos.home.honzakostejn.programs.hyprland.enable {
    # xdg.dataFile."icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
    };
  };
}
