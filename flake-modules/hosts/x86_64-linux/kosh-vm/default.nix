{ inputs, self, ... }: {
  flake.nixosModules.hostKoshVm = { ... }: {
    imports = [
      self.nixosModules.environment
      self.nixosModules.programs-common
      self.nixosModules.programs-docker
      self.nixosModules.services-cloudflare-warp
      self.nixosModules.users-honzakostejn-cli
      ./configuration.nix
    ];
  };

  flake.nixosConfigurations.kosh-vm = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [ self.nixosModules.hostKoshVm ];
  };
}
