{ lib
, config
, pkgs
, ...
}: {
  options = {
    koshos.services.greetd = {
      enable = lib.mkEnableOption "greetd authentication daemon" // { default = false; };
    };
  };

  config = lib.mkIf config.koshos.services.greetd.enable {
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
          # autologin
          # password is still required by hyprlock
          # initial_session = {
          #   command = "${lib.getExe config.programs.hyprland.package}";
          #   user = "honzakostejn";
          # };
          default_session = session;
        };
      };
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
