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
  ];

  home.stateVersion = "24.05";

  # info about user and path it manages
  home.username = "honzakostejn";
  home.homeDirectory = "/home/honzakostejn";
 
  # let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # user packages
  home.packages = with pkgs; [
    firefox
    freerdp3
    git
    glxinfo
    kitty
    neofetch
    neovim
    rofi-wayland
    ungoogled-chromium
    vscode

    inputs.swww.packages.${pkgs.system}.swww
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };
}