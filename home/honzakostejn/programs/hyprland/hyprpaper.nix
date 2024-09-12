{
  inputs,
  pkgs,
  ...
}: let
  wallpaper = let
    url = "https://github.com/honzakostejn/koshOS/blob/main/assets/wallpapers/mf-doom.jpg?raw=true";
    sha256 = "0bvz5kjvqvqsmypbjmgmhqr40p4m5fpfl1kgln9r6vgsl42v7wdq";
    ext = "jpg";
  in
    builtins.fetchurl {
      name = "wallpaper-${sha256}.${ext}";
      inherit url sha256;
    };
in {
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      ipc = "off";
      splash = true;
      splash_offset = 2.0;

      preload = [
        "${wallpaper}"
      ];

      wallpaper = [
        ", ${wallpaper}"
      ];
    };
  };
}