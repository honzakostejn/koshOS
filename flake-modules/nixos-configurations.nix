{ inputs, ... }: {
  flake.nixosConfigurations = {
    x86_64-iso-image = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ../hosts/x86_64-linux/iso-image
      ];
    };

    m1-qemu = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ../hosts/aarch64-linux/m1-qemu
      ];
    };

    framework = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ../hosts/x86_64-linux/framework
      ];
    };

    jellyfin-nixos-on-azure = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ../hosts/x86_64-linux/jellyfin-nixos-on-azure
      ];
    };

    handkerchief = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ../hosts/aarch64-linux/handkerchief
      ];
    };

    kosh-vm = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ../hosts/x86_64-linux/kosh-vm
      ];
    };
  };
}
