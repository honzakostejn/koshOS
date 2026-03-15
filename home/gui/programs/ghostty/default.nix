{ inputs
, pkgs
, ...
}: {
    programs.ghostty = {
      enable = true;
      package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        window-decoration = "none";
        window-padding-balance = true;
        window-padding-color = "extend";

        theme = "TokyoNight Night";
        background-opacity = 1;

        font-size = 15;
        font-family = "JetBrains Mono";

        bell-features = "system";
      };
    };
}
