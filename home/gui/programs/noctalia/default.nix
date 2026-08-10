{ config, inputs, pkgs, ... }:
let
  cfg = config.programs.noctalia;
  defaultWallpaper = "${cfg.package}/share/noctalia/assets/noctalia-wallpaper.png";

  minuteInSeconds = 60;
  screenOffTimeout = 3 * minuteInSeconds;

  suspendOnBattery = pkgs.writeShellScript "suspend-on-battery" ''
    if [ "$(cat /sys/class/power_supply/ACAD/online)" -eq 0 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    # declarative layer, written to ~/.config/noctalia/config.toml. Noctalia
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

        monitor = {
          # overrides for the portrait monitors
          "7MT0167B2AEL" = {
            position = "top";
          };
          "7MT0162411FL" = {
            position = "top";
          };
        };
      };

      shell = {
        font_family = "JetBrains Mono";
        lang = "en";
      };

      lockscreen = {
        enabled = true;
        lock_before_suspend = true;
        fingerprint = true;
        blurred_desktop = true;
        blur_intensity = 0.5;
        tint_intensity = 0.3;
      };

      idle = {
        behavior_order = [ "screen-off" "suspend" ];

        behavior = {
          "screen-off" = {
            enabled = true;
            timeout = screenOffTimeout;
            action = "screen_off";
          };

          suspend = {
            enabled = true;
            timeout = screenOffTimeout + 10;
            action = "command";
            command = "${suspendOnBattery}";
          };
        };
      };

      theme = {
        builtin = "Catppuccin";
        mode = "dark";
        source = "builtin";
        templates = {
          builtin_ids = [
            "alacritty"
            "btop"
            "cava"
            "emacs"
            "foot"
            "gtk3"
            "gtk4"
            "ghostty"
            "helix"
            "hyprland"
            "kcolorscheme"
            "kitty"
            "labwc"
            "mango"
            "niri"
            "qt"
            "scroll"
            "starship"
            "sway"
            "wezterm"
          ];
        };
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
