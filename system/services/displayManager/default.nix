{ lib
, config
, pkgs
, ...
}: {
  options = {
    koshos.services.displayManager = {
      enable = lib.mkEnableOption "login display manager" // { default = false; };
    };

    # services.displayManager.autoLogin.command = lib.mkOption {
    #   type = lib.types.str;
    #   default = "";
    #   description = ''
    #     Command to run after auto login. If empty, no command is run.
    #   '';
    # };
  };

  config = lib.mkIf config.koshos.services.displayManager.enable {
    services.displayManager ={
      enable = true;
      # ly = {
      #   enable = true;
      # };
      dms-greeter = {
        enable = true;
        compositor.name = "hyprland";
      };
      autoLogin = {
        # password is still required in hyprlock
        enable = true;
        user = "honzakostejn";
        command = "hyprland";
      };
    };
    security.pam.services.displayManager.enableGnomeKeyring = true;
    # security.pam.services.dms-greeter.enableGnomeKeyring = true;
  };
}
