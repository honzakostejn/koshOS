{ inputs
, lib
, pkgs
, config
, ...
}:
let
  winboatPackage = inputs.winboat.packages."${pkgs.system}".winboat;
  # winboatLocalPackage = pkgs.runCommand "winboat-local" {
  #   src = ./winboat.sh;
  # } ''
  #   mkdir -p $out/bin
  #   install -m755 $src $out/bin/winboat-local
  # '';
in
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
      winboatPackage
      # winboatLocalPackage
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
