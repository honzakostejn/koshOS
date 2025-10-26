{ lib
, pkgs
, config
, ...
}: {
  options = {
    koshos.home.honzakostejn.programs.teams-for-linux = {
      enable = lib.mkEnableOption "Teams for Linux" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.teams-for-linux.enable {
    home.packages = with pkgs; [
      teams-for-linux
    ];

    xdg.configFile."teams-for-linux/Preferences".text = ''
      {
        "migrated_user_scripts_toggle": true,
        "secure": "true",
        "spellcheck": {
          "dictionaries": [
            "cs-CZ",
            "en-US"
          ],
          "dictionary": ""
        }
      }
    '';
  };
}
