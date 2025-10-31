{ config, pkgs, lib, ... }:
{
  imports = [
    ../../../home/honzakostejn/programs/opencode
    ../../../home/honzakostejn/programs/nushell
    ../../../home/honzakostejn/programs/yazi
    ../../../home/honzakostejn/programs/helix
  ];

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    git
    gh
    vim
  ];

  home.sessionVariables = {
    EDITOR = "helix";
  };

  # programs.nushell = {
  #   extraEnv = ''
  #     $env.PATH = ($env.PATH | split row (char esep) | prepend "/data/data/com.termux/files/usr/bin/applets" | prepend "/data/data/com.termux/files/usr/bin" | prepend ($env.HOME + "/bin"))
  #   '';
  # };

  # home.file."bin/opencode" = {
  #   text = ''
  #     #!/usr/bin/env bash
  #     export PATH="/data/data/com.termux/files/usr/bin:/data/data/com.termux/files/usr/bin/applets:$PATH"
  #     exec ${config.home.homeDirectory}/.nix-profile/bin/opencode "$@"
  #   '';
  #   executable = true;
  # };

  home.file.".termux/termux.properties" = {
    text = ''
      # send escape for back key
      back-key=escape

      # ctrl = volume down
      shortcut.create-session=ctrl + t
      shortcut.next-session=ctrl + m
    '';
  };

  programs.yazi = {
    # kosh_phone has different keyboard layout than standard qwerty
    keymap = lib.mkForce { };
  };

  programs.helix = {
    settings = {
      # kosh_phone has different keyboard layout than standard qwerty
      keys = {
        normal = lib.mkForce {
          # yazi integration
          C-y = [
            ":sh rm -f /tmp/helix-yazi"
            ":insert-output yazi %{buffer_name} --chooser-file=/tmp/helix-yazi"
            ":insert-output echo \\x1b[?1049h\\x1b[?2004h > /dev/tty"
            ":open %sh{cat /tmp/helix-yazi}"
            ":redraw"
          ];
        };
      };
    };
  };
}
