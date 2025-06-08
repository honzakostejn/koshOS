{ ...
}: {
  imports = [
    ./steam
  ];

  programs.dconf.enable = true;
  programs.nix-ld.enable = true;
  programs.wireshark.enable = true;
}
