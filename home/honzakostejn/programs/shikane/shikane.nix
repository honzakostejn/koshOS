{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.shikane;
in {
  options = {
    services.shikane = {
      enable = mkEnableOption "Shikane, a more powerful kanshi alternative";
      package = mkOption {
        type = types.package;
        default = pkgs.shikane;
        description = "shikane derivation to use.";
      };
      systemdTarget = mkOption {
        type = types.listOf types.str;
        default = ["sway-session.target"];
        description = "systemd target to bind to.";
      };
      config = mkOption {
        type = types.str;
        default = ''
          [[profile]]
          name = "laptop builtin"
          [[profile.output]]
          match = "eDP-1"
          enable = true

          [[profile]]
          name = "monitor"
          [[profile.output]]
          match = "/HDMI-.-[1-9]/"
          enable = true
          [[profile.output]]
          match = "/DP-[1-9]/"
          enable = true
        '';
        description = "toml configuration";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."shikane/config.toml".text = cfg.config;

    systemd.user.services.shikane = {
      Unit = {
        Description = "Shikane dynamic display manager";
        PartOf = cfg.systemdTarget;
        Requires = cfg.systemdTarget;
        After = cfg.systemdTarget;
      };
      Service = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/shikane";
        Restart = "always";
      };
      Install = {WantedBy = cfg.systemdTarget;};
    };
  };
}