{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    koshos.home.honzakostejn.theming.qt = {
      enable = lib.mkEnableOption "Qt theming" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.theming.qt.enable {
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };
  };
}
