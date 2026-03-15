{ ... }: {
  flake.nixosModules.services-greetd = { lib, pkgs, config, ... }: {
    services.greetd =
      let
        session = {
          command = ''
            ${lib.getExe pkgs.tuigreet}
              --time
              --cmd ${lib.getExe config.programs.hyprland.package}
          '';
          user = "greeter";
        };
      in
      {
        enable = true;
        settings = {
          default_session = session;
        };
      };
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
