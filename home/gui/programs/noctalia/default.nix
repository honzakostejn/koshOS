{ config, inputs, ... }:
let
  cfg = config.programs.noctalia;
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

      shell = {
        font_family = "JetBrains Mono";
        lang = "en";
      };

      theme = {
        builtin = "Catppuccin";
        mode = "dark";
        source = "builtin";
      };

      wallpaper = {
        default.path = defaultWallpaper;
        last.path = defaultWallpaper;
      };

      widget.workspaces = {
        labels_only_when_occupied = true;
        # split-monitor-workspaces module names each workspace
        # "<numberIndex>_m<monitorId>", which keeps names
        # unique while the truncation below renders just the number.
        label_source = "name";
        max_label_chars = 1;
      };
    };
  };
}
