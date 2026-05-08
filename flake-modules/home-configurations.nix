{ inputs, self, ... }: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
    # inputs.whisp-away.nixosModules.home-manager
  ];

  flake.homeModules = {
    nixColors           = inputs.nix-colors.homeManagerModules.default;
    nixvim              = inputs.nixvim.homeModules.nixvim;
    hyprland            = inputs.hyprland.homeManagerModules.default;
    hyprdynamicmonitors = inputs.hyprdynamicmonitors.homeManagerModules.default;

    cli = ../home/cli;
    gui = ../home/gui;
  };

  flake.homeConfigurations = {
    honzakostejn = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs self; };
      modules = [ self.homeModules.cli self.homeModules.gui ];
    };
    "honzakostejn-cli" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs self; };
      modules = [ self.homeModules.cli ];
    };
  };
}
