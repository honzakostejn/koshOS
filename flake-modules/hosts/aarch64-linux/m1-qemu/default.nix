{ inputs, self, ... }: {
  flake.nixosModules.hostM1Qemu = { ... }: {
    imports = [
      self.nixosModules.programs-common
      ./configuration.nix
    ];
  };

  flake.nixosConfigurations.m1-qemu = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = { inherit inputs self; };
    modules = [ self.nixosModules.hostM1Qemu ];
  };
}
