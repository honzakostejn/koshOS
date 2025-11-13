{ lib
, pkgs
, config
, ...
}:
{
  options = {
    koshos.programs.waydroid = {
      enable = lib.mkEnableOption "Waydroid" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.koshos.programs.waydroid.enable {
    virtualisation.waydroid = {
      enable = true;
    };
  };
}
