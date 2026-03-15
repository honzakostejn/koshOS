{ ... }: {
  flake.nixosModules.services-display-manager = { ... }: {
    services.displayManager = {
      enable = true;
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
  };
}
