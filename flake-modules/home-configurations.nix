{ inputs, self, ... }: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeModules = {
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
