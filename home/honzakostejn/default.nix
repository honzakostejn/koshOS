{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default

    ./programs/ags
    ./programs/firefox
    ./programs/hyprland
    ./programs/hyprlock
    ./programs/shikane

    ./theming
  ];

  home.stateVersion = "24.05";

  # info about user and path it manages
  home.username = "honzakostejn";
  home.homeDirectory = "/home/honzakostejn";
 
  # let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # user packages
  home.packages = with pkgs; [
    git
    kitty
    mangohud
    neovim
    rofi-wayland
    teams-for-linux
    vscode
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  services.remmina.enable = true;
}