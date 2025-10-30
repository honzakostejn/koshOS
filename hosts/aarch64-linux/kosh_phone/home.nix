{ config, pkgs, ... }:
{
  imports = [
    ../../../home/honzakostejn/programs/opencode
    ../../../home/honzakostejn/programs/nushell
    ../../../home/honzakostejn/programs/yazi
  ];

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    git
    gh
    vim
  ];

  programs.nushell = {
    extraEnv = ''
      $env.PATH = ($env.PATH | split row (char esep) | prepend "/data/data/com.termux/files/usr/bin/applets" | prepend "/data/data/com.termux/files/usr/bin" | prepend ($env.HOME + "/bin"))
    '';
  };

  home.file."bin/opencode" = {
    text = ''
      #!/usr/bin/env bash
      export PATH="/data/data/com.termux/files/usr/bin:/data/data/com.termux/files/usr/bin/applets:$PATH"
      exec ${config.home.homeDirectory}/.nix-profile/bin/opencode "$@"
    '';
    executable = true;
  };

  programs.yazi = {
    # reset keymap to default
    keymap = { };
  };
}
