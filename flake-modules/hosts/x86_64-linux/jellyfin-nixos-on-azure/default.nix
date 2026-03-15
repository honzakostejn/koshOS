{ inputs, self, ... }: {
  flake.nixosModules.hostJellyfin = { ... }: {
    imports = [
      ./configuration.nix
    ];
  };

  flake.nixosConfigurations.jellyfin-nixos-on-azure = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [ self.nixosModules.hostJellyfin ];
  };
}
