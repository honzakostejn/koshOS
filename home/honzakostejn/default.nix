{ inputs
, pkgs
, lib
, ...
}: {
  imports = [
    ./programs
    ./services
    ./theming
    ./wayland
  ];

  home.stateVersion = "25.05";

  # info about user and path it manages
  home.username = "honzakostejn";
  home.homeDirectory = "/home/honzakostejn";

  # let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # user packages
  home.packages = with pkgs; [
    # dolphin
    rawtherapee

    bitwarden-desktop
    btop
    # blender
    cbonsai
    chromium
    # figma-linux
    git
    # kitty
    mangohud
    oversteer
    pandoc
    pavucontrol
    quickemu
    rofi-wayland
    teams-for-linux
    # tribler
    vlc

    # hyprpanel
    kanata

    # inputs.zen-browser.packages."x86_64-linux".beta
    # zen browser is still not in home-manager
    # => make sure to perform this config after the update
    # ==================================================
    # SETTINGS (about:config)
    # ==================================================
    # browser.ctrlTab.sortByRecentlyUsed = true
    # zen.tabs.vertical.right-side = true (until hover can be disabled)
    # zen.view.experimental-no-window-controls = false
    # ==================================================
    # EXTENSIONS (enable Bitwarden in Private mode)
    # ==================================================
    # - Bitwarden
    # - Vimium
    # - uBlock Origin
    # - Level up for Dynamics 365/Power Apps
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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # "default-web-browser" = [ "userapp-Zen-97YQ12.desktop" ];
      # "text/html" = [ "userapp-Zen-97YQ12.desktop" ];
      # "x-scheme-handler/http" = [ "userapp-Zen-97YQ12.desktop" ];
      # "x-scheme-handler/https" = [ "userapp-Zen-97YQ12.desktop" ];
      # "x-scheme-handler/about" = [ "userapp-Zen-97YQ12.desktop" ];
      # "x-scheme-handler/unknown" = [ "userapp-Zen-97YQ12.desktop" ];
    };
  };
}
