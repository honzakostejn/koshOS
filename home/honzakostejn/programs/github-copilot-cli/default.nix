{ lib
, inputs
, pkgs
, config
, ...
}:
{
  options = {
    koshos.home.honzakostejn.programs.github-copilot-cli = {
      enable = lib.mkEnableOption "GitHub Copilot CLI - AI coding assistant." // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.github-copilot-cli.enable {
    programs.bun = {
      enable = true;
    };

    # bash & nu aliases
    programs.bash.shellAliases = {
      copilot = "bunx copilot";
    };
    programs.nushell.shellAliases = {
      copilot = "bunx copilot";
    };

    # TODO: enable bell in config file (can't be done AOT right now, because of the plugins) 
  };
}
