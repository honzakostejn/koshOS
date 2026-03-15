{ inputs
, pkgs
, ...
}: {
    programs.quickshell = {
      enable = true;
      package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
      systemd = {
        enable = true;
      };
    };

    home.packages = with pkgs; [
      # dependencies
      wl-clipboard
    ];
    xdg.configFile."quickshell" = {
      source = ./.;
      recursive = true;
    };
}
