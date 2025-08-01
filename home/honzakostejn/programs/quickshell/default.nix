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
        enable = true;
      };
    };

    home.packages = with pkgs; [
      # dependencies
      wl-clipboard
    ];
    xdg.configFile."quickshell" = {
      source = ./.;
      recursive = true;
    };
  };
}
