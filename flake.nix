{
  description = "This is koshOS flake. honzakostejn's flavored NixOS configuration.";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    ags = {
      url = "github:Aylur/ags";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    swww = {
      url = "github:LGFae/swww";
    };
  };

  outputs = inputs @ { ... }: {
    nixosConfigurations = {
      m1-qemu = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };
        modules = with inputs; [
          ./systems/aarch64-linux/m1-qemu

          disko.nixosModules.disko

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.honzakostejn = import ./home/honzakostejn;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

      # framework = inputs.nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   specialArgs = { inherit inputs; };
      #   modules = [
      #     # disk configuration
      #     ./hosts/vm/disk-config.nix
      #     inputs.disko.nixosModules.disko

      #     # configuration
      #     ./hosts/vm/configuration.nix

      #     # make home-manager as a module of nixos
      #     # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
      #     inputs.home-manager.nixosModules.home-manager
      #     {
      #       inputs.home-manager.useGlobalPkgs = true;
      #       inputs.home-manager.useUserPackages = true;
      #       inputs.home-manager.users.honzakostejn = import ./home/honzakostejn/home.nix;
      #       inputs.home-manager.extraSpecialArgs = { inherit inputs; };
      #     }
      #   ];
      # };
    };
  };
}
