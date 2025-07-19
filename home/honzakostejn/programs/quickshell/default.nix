{ lib
, inputs
, pkgs
, config
, ...
}: {
  options = {
    koshos.home.honzakostejn.programs.quickshell = {
      enable = lib.mkEnableOption "Quickshell status bar" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.quickshell.enable {
    programs.quickshell = {
      enable = true;
      package = inputs.quickshell.packages.${pkgs.system}.default;
      systemd = {
        enable = false;
      };
    };

    # xdg.configFile."quickshell/modules/bar/Bar.qml".source = ./modules/bar/Bar.qml;
    # xdg.configFile."quickshell/shell.qml".source = ./shell.qml;
  };
}
