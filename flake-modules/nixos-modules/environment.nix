{ ... }: {
  flake.nixosModules.environment = { ... }: {
    environment = {
      sessionVariables = {
        # hint Electron apps to use wayland
        NIXOS_OZONE_WL = "1";

        # https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/credstores.md#freedesktoporg-secret-service-api
        GCM_CREDENTIAL_STORE = "secretservice";

        # https://discourse.nixos.org/t/how-to-install-xdg-desktop-portal-termfilechooser/62819/45
        # QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
      };

      # adds ~/.local/bin to PATH
      localBinInPath = true;
    };  
  };
}
