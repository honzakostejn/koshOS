{ inputs
, pkgs
, ...
}:
let
  wallpaper =
    let
      url = "https://github.com/flick0/dotfiles/blob/aurora/config/hypr/wallpapers/4.jpg?raw=true";
      sha256 = "1jar4ysprbk2k076ds0spzl64z0r155phfb4xh79mcbp5xvf6fcj";
      ext = "jpg";
    in
    builtins.fetchurl {
      name = "wallpaper-${sha256}.${ext}";
      inherit url sha256;
    };
    
in
{
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      ipc = "off";
      # splash = true;
      # splash_offset = 2.0;

      preload = [
        "${wallpaper}"
      ];

      wallpaper = [
        ", ${wallpaper}"
      ];
    };
  };
}
