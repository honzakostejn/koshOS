{ inputs, self, ... }: {
  flake.nixosModules.hostIsoImage = { ... }: {
    imports = [
      self.nixosModules.koshos
      ../../hosts/x86_64-linux/iso-image
    ];
  };

  flake.nixosConfigurations.x86_64-iso-image = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [ self.nixosModules.hostIsoImage ];
  };
}
