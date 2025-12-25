{ lib
, config
, pkgs
, ...
}: {
  options = {
    koshos.services.getty = {
      enable = lib.mkEnableOption "auto login console" // { default = false; };
    };
  };

  config = lib.mkIf config.koshos.services.getty.enable {
    services.getty ={
      autologinUser = "honzakostejn";
      autologinOnce = true;
      loginProgram = "${lib.getExe config.programs.hyprland.package}";
    };
    security.pam.services.getty.enableGnomeKeyring = true;
  };
}
