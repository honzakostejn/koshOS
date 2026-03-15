{ ... }: {
  flake.nixosModules.programs-steam = { ... }: {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;
  };
}
