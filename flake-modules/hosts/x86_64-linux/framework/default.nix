{ inputs, self, ... }: {
  flake.nixosModules.hostFramework = { ... }: {
    imports = [
      self.nixosModules.environment
      self.nixosModules.fonts
      self.nixosModules.hyprland
      self.nixosModules.programs-common
      self.nixosModules.programs-docker
      self.nixosModules.programs-steam
      self.nixosModules.programs-waydroid
      self.nixosModules.services-cloudflare-warp
      self.nixosModules.services-kanata
      self.nixosModules.services-sysc-greet
      self.nixosModules.users-honzakostejn
      ./configuration.nix
    ];
  };

  flake.nixosConfigurations.framework = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [ self.nixosModules.hostFramework ];
  };
}
