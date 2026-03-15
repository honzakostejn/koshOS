{ inputs, self, ... }: {
  flake.nixosModules.hostJellyfin = { ... }: {
    imports = [
      ./x86_64-linux/jellyfin-nixos-on-azure
    ];
  };

  flake.nixosConfigurations.jellyfin-nixos-on-azure = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [ self.nixosModules.hostJellyfin ];
  };
}
