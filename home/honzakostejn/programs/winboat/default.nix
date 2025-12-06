{ inputs
, lib
, pkgs
, config
, ...
}:
{
  options = {
    koshos.home.honzakostejn.programs.winboat = {
      enable = lib.mkEnableOption "WinBoat user configuration" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.winboat.enable {
    home.packages = [
      pkgs.winboat
      pkgs.freerdp
    ];

    # xdg.desktopEntries = {
    #   "Garmin Expressss" = {
    #     name = "Garmin Express";
    #     genericName = "Garmin Express";
    #     exec = "winboat manual express";
    #   };
    # };

    # xdg.desktopEntries = {
    #   "Visual Studio Code" = {
    #     name = "Visual Studio Code [Windows Edition]";
    #     genericName = "Visual Studio Code running on Windows via winboat";
    #     exec = "winboat manual code";
    #   };
    # };
  };
}
