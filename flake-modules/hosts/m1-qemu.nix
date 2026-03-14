{ inputs, self, ... }: {
  flake.nixosModules.hostM1Qemu = { ... }: {
    imports = [
      self.nixosModules.koshos
      ../../hosts/aarch64-linux/m1-qemu
    ];
  };

  flake.nixosConfigurations.m1-qemu = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = { inherit inputs self; };
    modules = [ self.nixosModules.hostM1Qemu ];
  };
}
