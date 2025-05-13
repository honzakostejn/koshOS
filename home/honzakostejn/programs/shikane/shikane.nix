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
      config = mkOption {
        type = types.str;
        default = ''
          [[profile]]
          name = "laptop builtin"
            [[profile.output]]
            match = "eDP-1"
            enable = true
        '';
        description = "toml configuration";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."shikane/config.toml".text = cfg.config;
  };
}