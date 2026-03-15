{ inputs, self, ... }: {
  flake.nixosModules.hostKoshVm = { ... }: {
    imports = [
      self.nixosModules.koshos
      self.nixosModules.users-honzakostejn-cli
      ../../hosts/x86_64-linux/kosh-vm
    ];
  };

  flake.nixosConfigurations.kosh-vm = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [ self.nixosModules.hostKoshVm ];
  };
}
