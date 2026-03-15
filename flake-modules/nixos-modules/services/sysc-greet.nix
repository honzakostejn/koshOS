{ inputs, ... }: {
  flake.nixosModules.services-sysc-greet = { ... }: {
    imports = [
      inputs.sysc-greet.nixosModules.default
    ];

    services.sysc-greet = {
      enable = true;
      compositor = "hyprland";
    };

    security.pam.services.sysc-greet.enableGnomeKeyring = true;
  };
}
