{ lib
, config
, pkgs
, ...
}:
{
  options = {
    koshos.home.honzakostejn.programs.satty = {
      enable = lib.mkEnableOption "Satty is a screenshot annotation tool" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.satty.enable {
    programs.satty = {
      enable = true;
      settings = {
        general = {
          # fullscreen = true;
          # corner-roundness = 12;
          # early-exit = false;
          # initial-tool = "arrow";
          output-filename = "~/screenshots/satty/%Y-%m-%d_%H:%M:%S.png";
          copy-command = "wl-copy";
          actions-on-escape = [
            "save-to-file"
            "save-to-clipboard"
            "exit"
          ];
        };
      };
    };
  };
}
