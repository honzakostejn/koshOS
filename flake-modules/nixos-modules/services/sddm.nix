{ ... }: {
  flake.nixosModules.services-sddm = { ... }: {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    security.pam.services.sddm.enableGnomeKeyring = true;
  };
}
