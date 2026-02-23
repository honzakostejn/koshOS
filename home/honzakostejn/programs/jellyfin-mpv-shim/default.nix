{ inputs
, lib
, pkgs
, config
, ...
}:
{
  options = {
    koshos.home.honzakostejn.programs.jellyfin-mpv-shim = {
      enable = lib.mkEnableOption "Jellyfin MPV Shim" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.jellyfin-mpv-shim.enable {
    services.jellyfin-mpv-shim = {
      enable = false;
    };

    home.packages = with pkgs; [
      jellyfin-mpv-shim
    ];
  };
}
