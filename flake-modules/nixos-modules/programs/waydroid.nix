{ ... }: {
  flake.nixosModules.programs-waydroid = { ... }: {
    virtualisation.waydroid.enable = true;
  };
}
