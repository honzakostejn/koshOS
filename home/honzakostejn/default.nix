{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./programs/ags
    # ./programs/ags/backup.nix
    ./programs/firefox
    ./programs/foot
    ./programs/hypridle
    ./programs/hyprland
    ./programs/hyprlock
    ./programs/nixvim
    ./programs/shikane
    # ./programs/wezterm
    ./programs/vscode

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

    btop
    # blender
    cbonsai
    figma-linux
    git
    # kitty
    mangohud
    quickemu
    rofi-wayland
    teams-for-linux

    # hyprpanel
    kanata
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