{ lib
, config
, inputs
, pkgs
, ...
}:
let
  font_family = "JetBrains Mono";

  # background is mapped to the last monitor state (screenshot)
  # hyprlock can't evaluate this at the runtime,
  # so there's pregenerated config for "extra" monitors at design time
  generateBackground = monitor: {
    monitor = monitor;
    path = "/tmp/screenshots/${monitor}/hyprlock.png";
    blur_passes = 2;
    blur_size = 5;
  };
  backgrounds = map generateBackground (import ./monitors.nix);

in
{
  options = {
    koshos.home.honzakostejn.programs.hyprlock = {
      enable = lib.mkEnableOption "Hyprlock screen locker" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.hyprlock.enable {
    programs.hyprlock = {
      enable = true;

      package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock;

      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = false;
          no_fade_in = true;
        };

        background = backgrounds;

        input-field = [
          {
            size = "300, 50";

            outline_thickness = 1;

            outer_color = "rgb(255, 100, 100)";
            inner_color = "rgb(0, 0, 0)";
            font_color = "rgb(255, 255, 255)";

            fade_on_empty = false;
            placeholder_text = "Password...";
            inherit font_family;

            dots_spacing = 0.2;
            dots_center = true;
          }
        ];

        label = [{
          monitor = "";
          text = "$TIME";
          inherit font_family;
          font_size = 50;
          color = "rgb(255, 100, 100)";

          position = "0, 150";

          valign = "center";
          halign = "center";
        }
          {
            monitor = "";
            text = "cmd[update:3600000] date +'%a %b %d'";
            inherit font_family;
            font_size = 20;
            color = "rgb(255, 100, 100)";

            position = "0, 50";

            valign = "center";
            halign = "center";
          }];
      };
    };
  };
}
