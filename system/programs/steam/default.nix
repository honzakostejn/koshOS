{ lib
, config
, ...
}: {
  options = {
    koshos.programs.steam = {
      enable = lib.mkEnableOption "Steam client" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.programs.steam.enable {
    programs.steam = {
      enable = true; # there is no aarch64 steam client
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;
  };
}
