{ inputs, self, ... }: {
  flake.nixosModules.hostJellyfin = { ... }: {
    imports = [
      self.nixosModules.rclone-blob-koshstorage
      ./configuration.nix
    ];
  };

  flake.nixosConfigurations.jellyfin-nixos-on-azure = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [ self.nixosModules.hostJellyfin ];
  };
}
