{ pkgs
, ...
}:
{
    services.jellyfin-mpv-shim = {
      enable = false;
    };

    home.packages = with pkgs; [
      jellyfin-mpv-shim
    ];
}
