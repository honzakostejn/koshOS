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

    hyprland = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

      type = "github";
      owner = "hyprwm";
      repo = "Hyprland";
      # submodules = true;
      # ref = "refs/tags/v0.46.0";
    };

    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

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

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # nur = {
    #   type = "github";
    #   owner = "nix-community";
    #   repo = "NUR";
    # };

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };

    swww = {
      url = "github:LGFae/swww";
    };

    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          # inputs.nur.overlay
          # inputs.hyprpanel.overlay
        ];
      };

    in
    {
      nixosConfigurations = {
        x86_64-iso-image = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./systems/x86_64-linux/iso-image
          ];
        };

        m1-qemu = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./systems/aarch64-linux/m1-qemu
          ];
        };

        framework = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs; };
          modules = [
            ./systems/x86_64-linux/framework
          ];
        };
      };
    };
}
