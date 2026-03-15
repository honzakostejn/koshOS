{ pkgs
, ...
}: {
  imports = [
    ./programs
    ./services
    ./theming
    ./wayland
  ];

  home.packages = with pkgs; [
    rawtherapee
    bitwarden-desktop
    # blender
    chromium
    # figma-linux
    # kitty
    mangohud
    oversteer
    pavucontrol
    quickemu
    rofi
    # teams-for-linux
    vlc
    popcorntime # platform specific
    bruno
    obs-studio
    # hyprpanel
    kanata
    trezor-suite
    jellyfin-desktop
    tor-browser
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

  services.kdeconnect.enable = true;
}
