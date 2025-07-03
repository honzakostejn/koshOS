{
  description = "This is koshOS flake. honzakostejn's flavored NixOS configuration.";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "refs/heads/nixos-unstable";
    };

    ags = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        astal.follows = "astal";
      };

      type = "github";
      owner = "Aylur";
      repo = "ags";
    };

    astal = {
      inputs.nixpkgs.follows = "nixpkgs";

      type = "github";
      owner = "Aylur";
      repo = "astal";
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
      type = "github";
      owner = "ghostty-org";
      repo = "ghostty";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
      ref = "refs/tags/v0.8.0";
    };

    hyprland = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprutils.follows = "hyprutils";
      };

      type = "github";
      owner = "hyprwm";
      repo = "Hyprland";
      ref = "refs/tags/v0.49.0";
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

    hyprsplit = {
      inputs = {
        hyprland.follows = "hyprland";
      };

      type = "github";
      owner = "shezdy";
      repo = "hyprsplit";
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

    split-monitor-workspaces = {
      inputs = {
        hyprland.follows = "hyprland";
      };

      type = "github";
      owner = "Duckonaut";
      repo = "split-monitor-workspaces";
    };

    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };

    # hyprpaper = {
    #   url = "github:hyprwm/hyprpaper";
    #   inputs = {
    #     hyprlang.follows = "hyprland/hyprlang";
    #     hyprutils.follows = "hyprland/hyprutils";
    #     nixpkgs.follows = "hyprland/nixpkgs";
    #     systems.follows = "hyprland/systems";
    #   };
    # };

    # hyprpanel = {
    #   type = "github";
    #   owner = "Jas-SinghFSU";
    #   repo = "HyprPanel";
    # };

    # nur = {
    #   type = "github";
    #   owner = "nix-community";
    #   repo = "NUR";
    # };

    # swww = {
    #   url = "github:LGFae/swww";
    # };

    # wezterm = {
    #   url = "github:wez/wezterm/main?dir=nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # zen-browser = {
    #   type = "github";
    #   owner = "0xc000022070";
    #   repo = "zen-browser-flake";
    # };
  };

  outputs = { self, ... }@inputs:
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
    };
}
