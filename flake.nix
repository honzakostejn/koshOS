{
  description = "This is koshOS flake. honzakostejn's flavored NixOS configuration.";

  inputs = {
    ### nixpkgs ###
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "refs/heads/nixos-unstable";
    };

    nixpkgs-stable = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "refs/heads/master";
    };

    ### home-manager ###
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    ### hypr ecosystem ###
    hyprland = {
      type = "github";
      owner = "hyprwm";
      repo = "Hyprland";
      ref = "refs/tags/v0.52.2";
    };

    hypridle = {
      type = "github";
      owner = "hyprwm";
      repo = "hypridle";
    };

    hyprlock = {
      type = "github";
      owner = "hyprwm";
      repo = "hyprlock";
    };

    split-monitor-workspaces = {
      inputs = {
        hyprland.follows = "hyprland";
      };

      type = "github";
      owner = "Duckonaut";
      repo = "split-monitor-workspaces";
      ref = "refs/tags/v0.52.2";
    };

    ### programs ###
    ghostty = {
      inputs.nixpkgs.follows = "nixpkgs";

      type = "github";
      owner = "ghostty-org";
      repo = "ghostty";
    };

    helix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

      type = "github";
      owner = "helix-editor";
      repo = "helix";
    };

    nixvim = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

      type = "github";
      owner = "nix-community";
      repo = "nixvim";
    };

    opencode = {
      type = "github";
      owner = "sst";
      repo = "opencode";
    };

    quickshell = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # ref = "refs/tags/v0.1.0";
    };

    yazi = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

      type = "github";
      owner = "sxyazi";
      repo = "yazi";
    };

    ### misc ###
    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

      type = "github";
      owner = "nix-community";
      repo = "lanzaboote";
    };

    sysc-greet = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

      type = "github";
      owner = "Nomadcxx";
      repo = "sysc-greet";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.home-manager.follows = "home-manager-stable";
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { system = system; };
    in
    {
      packages = {
        # aarch64-linux = {
        #   image-handkerchief = self.nixosConfigurations.handkerchief.config.system.build.sdImage;
        # };
        x86_64-linux = {
          image-handkerchief = self.nixosConfigurations.handkerchief.config.system.build.sdImage;
        };
      };

      nixosConfigurations = {
        x86_64-iso-image = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/x86_64-linux/iso-image
          ];
        };

        m1-qemu = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/aarch64-linux/m1-qemu
          ];
        };

        framework = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/x86_64-linux/framework
          ];
        };

        jellyfin-az-nixos = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/x86_64-linux/jellyfin-az-nixos
          ];
        };

        handkerchief = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/aarch64-linux/handkerchief
          ];
        };
      };

      nixOnDroidConfigurations = {
        kosh_phone = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
          pkgs = import inputs.nix-on-droid.inputs.nixpkgs {
            system = "aarch64-linux";
            overlays = [
              inputs.nix-on-droid.overlays.default
            ];
          };
          modules = [
            ./hosts/aarch64-linux/kosh_phone
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
