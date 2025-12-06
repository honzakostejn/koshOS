{
  description = "This is koshOS flake. honzakostejn's flavored NixOS configuration.";

  inputs = {
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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprutils = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

      type = "github";
      owner = "hyprwm";
      repo = "hyprutils";
    };

    hyprland = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprutils.follows = "hyprutils";
      };

      type = "github";
      owner = "hyprwm";
      repo = "Hyprland";
      # ref = "refs/tags/v0.50.0";
    };

    hyprlock = {
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };

      type = "github";
      owner = "hyprwm";
      repo = "hyprlock";
    };

    lanzaboote = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

      type = "github";
      owner = "nix-community";
      repo = "lanzaboote";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
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

    split-monitor-workspaces = {
      inputs = {
        hyprland.follows = "hyprland";
      };

      type = "github";
      owner = "Duckonaut";
      repo = "split-monitor-workspaces";
    };

    quickshell = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # ref = "refs/tags/v0.1.0";
    };

    winapps = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

      type = "github";
      owner = "winapps-org";
      repo = "winapps";
    };

    yazi = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

      type = "github";
      owner = "sxyazi";
      repo = "yazi";
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
