{ config, inputs, ... }:
let
  cfg = config.programs.noctalia;

  # Shared settings for every lockscreen login box; only the placement differs
  # per output, so the geometry lives in the widget entries below.
  loginBoxSettings = {
    background_color = "surface_variant";
    background_opacity = 0.88;
    background_radius = 12.0;
    center_password_text = false;
    input_opacity = 1.0;
    input_radius = 6.0;
    layout = "regular";
    show_caps_lock = true;
    show_keyboard_layout = true;
    show_login_button = true;
    show_media = true;
    show_session_buttons = true;
    show_unlock_hint = true;
    show_weather = true;
  };

  defaultWallpaper = "${cfg.package}/share/noctalia/assets/noctalia-wallpaper.png";
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    # Declarative layer, written to ~/.config/noctalia/config.toml. Noctalia
    # never rewrites this file; anything changed through the GUI lands in
    # ~/.local/state/noctalia/settings.toml and wins over these values until
    # that override file is cleared.
    settings = {
      bar.default = {
        background_opacity = 0.5;
        font_family = "JetBrains Mono";
        margin_edge = 10;
        margin_ends = 10;
        position = "left";
        scale = 1.2;
        shadow = false;
        thickness = 40;
      };

      control_center.calendar.show_events_card = false;

      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@eDP-1"
          "lockscreen-login-box@DP-2"
        ];

        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };

        widget = {
          "lockscreen-login-box@eDP-1" = {
            box_height = 196.0;
            box_width = 810.0;
            cx = 1128.0;
            cy = 1322.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "login_box";
            settings = loginBoxSettings;
          };

          "lockscreen-login-box@DP-2" = {
            box_height = 196.0;
            box_width = 810.0;
            cx = 1280.0;
            cy = 1258.0;
            output = "DP-2";
            rotation = 0.0;
            type = "login_box";
            settings = loginBoxSettings;
          };
        };
      };

      shell = {
        font_family = "JetBrains Mono";
        lang = "en";
      };

      theme = {
        builtin = "Catppuccin";
        # Fetched at runtime into ~/.local/state/noctalia/community-palettes,
        # so it only takes effect while source = "community".
        community_palette = "Oxocarbon";
        mode = "dark";
        source = "builtin";
        wallpaper_scheme = "m3-content";
      };

      wallpaper = {
        default.path = defaultWallpaper;
        last.path = defaultWallpaper;
      };

      widget.workspaces.labels_only_when_occupied = true;
    };
  };
}
