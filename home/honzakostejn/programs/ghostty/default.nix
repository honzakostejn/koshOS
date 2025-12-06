{ inputs
, pkgs
, lib
, config
, ...
}: {
  options = {
    koshos.home.honzakostejn.programs.ghostty = {
      enable = lib.mkEnableOption "Ghostty is a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU acceleration." // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.ghostty.enable {
    programs.ghostty = {
      enable = true;
      package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        window-decoration = "none";
        window-padding-balance = true;
        window-padding-color = "extend";

        theme = "TokyoNight Night";
        background-opacity = 1;

        font-size = 15;
        font-family = "JetBrains Mono";
      };
    };
  };
}
