{ lib
, inputs
, pkgs
, config
, ...
}:
{
  options = {
    koshos.home.honzakostejn.programs.opencode = {
      enable = lib.mkEnableOption "opencode - AI coding agent, built for the terminal." // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.opencode.enable {
    programs.opencode = {
      enable = true;
      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      enableMcpIntegration = true;
      settings = {
        theme = "tokyonight";
        agent = {
          # http://opencode.ai/docs/agents/#options
        };
        formatter = {
          # http://opencode.ai/docs/formatters/#custom-formatters
          nix = {
            extensions = [ ".nix" ];
            command = [
              "${pkgs.nixfmt-rfc-style}/bin/nixfmt"
              "$FILE"
            ];
          };
        };
      };
    };

    xdg.configFile."opencode" = {
      source = ./.;
      recursive = true;
    };
  };
}
