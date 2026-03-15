{ ... }: {
  programs.nushell = {
    enable = true;
    shellAliases = {
      "koshos rebuild" = "sudo nixos-rebuild switch --flake ~/repos/koshos#framework";
    };
  };
}
