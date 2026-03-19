{ inputs
, pkgs
, ...
}: {
  environment = {
    sessionVariables = {
      # hint Electron apps to use wayland
      NIXOS_OZONE_WL = "1";

      # https://discourse.nixos.org/t/how-to-install-xdg-desktop-portal-termfilechooser/62819/45
      # QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
    };

    systemPackages = with pkgs; [
      fastfetch
      gh
      git
      htop
      jq
      nixpkgs-fmt
      usbutils
    ];

    # adds ~/.local/bin to PATH
    localBinInPath = true;
  };
}
