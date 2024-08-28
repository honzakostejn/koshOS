{
  config,
  inputs,
  pkgs,
  ...
}: let
  font_family = "JetBrains Mono";
in {
  programs.hyprlock = {
    enable = true;

    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = false;
        no_fade_in = true;
      };

      background = [
        {
          monitor = "";
        }
      ];

      input-field = [
        {
          monitor = "Virtual-1";

          size = "300, 50";

          outline_thickness = 1;

          outer_color = "rgb(255, 100, 100)";
          inner_color = "rgb(0, 0, 0)";
          font_color = "rgb(255, 255, 255)";

          fade_on_empty = false;
          placeholder_text = ''<span font_family="${font_family}" foreground="##255,255,255">Password...</span>'';

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
}