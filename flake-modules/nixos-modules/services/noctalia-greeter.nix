{ inputs, ... }: {
  flake.nixosModules.services-noctalia-greeter = { pkgs, ... }:
    let
      noctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      imports = [
        inputs.noctalia-greeter.nixosModules.default
      ];

      programs.noctalia-greeter = {
        enable = true;

        # full greeter.toml, symlinked from the store into
        # /var/lib/noctalia-greeter on every activation. Mutable Sync/UI data
        # lands in sync.toml next to it and loses against the keys set here.
        settings = {
          # picker label from `noctalia-greeter sessions`, not the .desktop id.
          session.default = "Hyprland";
          user.default = "honzakostejn";

          appearance = {
            scheme = "Catppuccin";
            theme_mode = "dark";
            font_family = "JetBrains Mono";
            wallpaper = {
              path = "${noctalia}/share/noctalia/assets/noctalia-wallpaper.png";
              fill_mode = "crop";
            };
          };

          cursor = {
            theme = "Bibata-Modern-Classic";
            size = 16;
            path = "${pkgs.bibata-cursors}/share/icons";
          };

          keyboard = {
            layout = "us,cz";
            variant = ",qwerty";
          };
        };
      };

      # greetd is what noctalia-greeter runs under, so the keyring gets
      # unlocked by the login password there.
      security.pam.services.greetd.enableGnomeKeyring = true;
    };
}
