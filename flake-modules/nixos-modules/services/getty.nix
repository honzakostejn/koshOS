{ ... }: {
  flake.nixosModules.services-getty = { lib, config, ... }: {
    services.getty = {
      autologinUser = "honzakostejn";
      autologinOnce = true;
      loginProgram = "${lib.getExe config.programs.hyprland.package}";
    };
    security.pam.services.getty.enableGnomeKeyring = true;
  };
}
