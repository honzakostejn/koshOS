{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./programs/ags
    # ./programs/ags/backup.nix
    ./programs/firefox
    ./programs/hypridle
    ./programs/hyprland
    ./programs/hyprlock
    ./programs/shikane
    ./programs/wezterm

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
    # dolphin
    rawtherapee

    blender
    cava
    cbonsai
    git
    # kitty
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
  services.dunst.enable = true;
}