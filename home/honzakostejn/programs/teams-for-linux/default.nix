{ lib
, pkgs
, config
, ...
}:
let
  teamsForLinuxPkg = pkgs.teams-for-linux.overrideAttrs (oldAttrs: {
    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "teams-for-linux.NETWORG";
        exec = ''teams-for-linux --class="teams-networg" --user-data-dir="${config.home.homeDirectory}/.teams/NETWORG" %U'';
        icon = "teams-for-linux";
        desktopName = "Microsoft Teams [NETWORG]";
        comment = oldAttrs.meta.description;
        categories = [
          "Network"
          "InstantMessaging"
          "Chat"
        ];
        mimeTypes = [ "x-scheme-handler/msteams" ];
      })
      (pkgs.makeDesktopItem {
        name = "teams-for-linux.CETIN";
        exec = ''teams-for-linux --class="teams-cetin" --user-data-dir="${config.home.homeDirectory}/.teams/CETIN" %U'';
        icon = "teams-for-linux";
        desktopName = "Microsoft Teams [CETIN]";
        comment = oldAttrs.meta.description;
        categories = [
          "Network"
          "InstantMessaging"
          "Chat"
        ];
        mimeTypes = [ "x-scheme-handler/msteams" ];
      })
    ];
  });
in
{
  options = {
    koshos.home.honzakostejn.programs.teams-for-linux = {
      enable = lib.mkEnableOption "Teams for Linux" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.teams-for-linux.enable {
    home.packages = [
      teamsForLinuxPkg
    ];

    home.file = {
      ".teams/NETWORG/config.json".source = ./config.json;
      ".teams/CETIN/config.json".source = ./config.json;
    };
  };
}