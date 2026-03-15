{ inputs, self, ... }: {
  flake.nixosModules.hostHandkerchief = { ... }: {
    imports = [
      self.nixosModules.programs-common
      self.nixosModules.services-cloudflare-warp
      ./configuration.nix
    ];
  };

  flake.nixosConfigurations.handkerchief = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = { inherit inputs self; };
    modules = [ self.nixosModules.hostHandkerchief ];
  };
}
