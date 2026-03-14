{ inputs, self, ... }: {
  flake.nixosModules.hostFramework = { ... }: {
    imports = [
      self.nixosModules.koshos
      self.nixosModules.hyprland
      ../../hosts/x86_64-linux/framework
    ];
  };

  flake.nixosConfigurations.framework = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [ self.nixosModules.hostFramework ];
  };
}
