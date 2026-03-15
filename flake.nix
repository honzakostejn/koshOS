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
        # NixOS feature modules
        ./flake-modules/nixos-modules/hyprland.nix
        ./flake-modules/nixos-modules/fonts.nix
        ./flake-modules/nixos-modules/programs/common.nix
        ./flake-modules/nixos-modules/programs/docker.nix
        ./flake-modules/nixos-modules/programs/steam.nix
        ./flake-modules/nixos-modules/programs/virt-manager.nix
        ./flake-modules/nixos-modules/programs/waydroid.nix
        ./flake-modules/nixos-modules/services/cloudflare-warp.nix
        ./flake-modules/nixos-modules/services/display-manager.nix
        ./flake-modules/nixos-modules/services/getty.nix
        ./flake-modules/nixos-modules/services/greetd.nix
        ./flake-modules/nixos-modules/services/kanata.nix
        ./flake-modules/nixos-modules/services/sysc-greet.nix
        ./flake-modules/nixos-modules/users/honzakostejn.nix
        ./flake-modules/nixos-modules/users/honzakostejn-cli.nix
        # Per-host configurations
        ./flake-modules/hosts/framework.nix
        ./flake-modules/hosts/handkerchief.nix
        ./flake-modules/hosts/m1-qemu.nix
        ./flake-modules/hosts/iso-image.nix
        ./flake-modules/hosts/jellyfin-nixos-on-azure.nix
        ./flake-modules/hosts/kosh-vm.nix
        # Home-manager
        ./flake-modules/home-configurations.nix
        ./flake-modules/home-modules.nix
        # Other outputs
        ./flake-modules/nix-on-droid.nix
        ./flake-modules/packages.nix
        ./flake-modules/dev-shell.nix
      ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
    };
}
