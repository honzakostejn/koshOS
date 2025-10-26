{ lib
, config
, pkgs
, ...
}: {
  options = {
    koshos.services.greetd = {
      enable = lib.mkEnableOption "greetd authentication daemon" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.services.greetd.enable {
    services.greetd =
      let
        session = {
          # this logs the user in automatically,
          # because there's no greeter specified in the command
          command = "${lib.getExe pkgs.tuigreet} --time --cmd ${lib.getExe config.programs.hyprland.package}";
          user = "honzakostejn";
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
