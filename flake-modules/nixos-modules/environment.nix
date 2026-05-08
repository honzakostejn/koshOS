{ ... }: {
  flake.nixosModules.environment = { ... }: {
    environment = {
      sessionVariables = {
        # hint Electron apps to use wayland
        NIXOS_OZONE_WL = "1";

        # https://github.com/git-ecosystem/git-credential-manager/blob/release/docs/credstores.md#gpgpass-compatible-files
        GCM_CREDENTIAL_STORE = "secretservice";

        # https://discourse.nixos.org/t/how-to-install-xdg-desktop-portal-termfilechooser/62819/45
        # QT_QPA_PLATFORMTHEME = "xdgdesktopportal";

        # https://learn.microsoft.com/en-us/dotnet/core/runtime-config/globalization
        DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
      };

      # adds ~/.local/bin to PATH
      localBinInPath = true;
    };  
  };
}
