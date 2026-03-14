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
      ref = "refs/tags/v0.53.1";
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
      ref = "refs/tags/v0.53.1";
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
      owner = "devmanuelli"; # fork that supports github copilot
      ref = "refs/heads/textDocument/inlineCompletion"; # fork that supports github copilot
      # owner = "helix-editor";
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
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

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

    hyprdynamicmonitors = {
      url = "github:fiffeek/hyprdynamicmonitors";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./flake-modules/nixos-configurations.nix
        ./flake-modules/home-configurations.nix
        ./flake-modules/nix-on-droid.nix
        ./flake-modules/packages.nix
        ./flake-modules/dev-shell.nix
      ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
    };
}
