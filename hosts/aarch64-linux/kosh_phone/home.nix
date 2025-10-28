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

  programs.yazi = {
    # reset keymap to default
    keymap = { };
  };
}
