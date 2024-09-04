{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./programs/ags
    
    inputs.hyprland.homeManagerModules.default
    ./programs/hyprland
    ./programs/hyprlock
    ./programs/firefox

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
    freerdp3
    git
    glxinfo
    kitty
    mangohud
    neofetch
    neovim
    # pamixer
    rofi-wayland
    teams-for-linux
    ungoogled-chromium
    vscode
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };
}