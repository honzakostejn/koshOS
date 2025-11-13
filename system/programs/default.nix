{
  ...
}:
{
  imports = [
    ./docker
    ./steam
    # ./virt-manager
    ./waydroid
  ];

  programs.dconf.enable = true;
  programs.nix-ld.enable = true;
  programs.wireshark.enable = true;
}
