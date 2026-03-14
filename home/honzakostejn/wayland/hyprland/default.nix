{ lib
, config
, self
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
    self.homeModules.hyprland

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

    # changing file chooser to yazi
    # xdg.portal = {
    #   enable = true;
    #   extraPortals = with pkgs; [
    #     xdg-desktop-portal-termfilechooser
    #   ];
    #   config = {
    #     common = {
    #       default = [ "hyprland" ];
    #       "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
    #     };
    #     hyprland = {
    #       default = [ "hyprland" ];
    #       "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
    #     };
    #   };
    # };
    # xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    #   [filechooser]
    #   cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    #   default_dir=$HOME/Downloads
    #   env=TERMCMD=ghostty --title="terminal-filechooser" -e
    #   open_mode=suggested
    #   save_mode=last
    # '';
  };
}
