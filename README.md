# 🗑️ koshOS
honzakostejn's dotfiles

# instructions
echo "password" > /tmp/secret.key # luks password
sudo nix run github:nix-community/disko#disko-install -- --flake github:honzakostejn/koshos#framework --write-efi-boot-entries --disk main /dev/nvme0n1 

# useful commands
nix run nixpkgs#nixos-generators -- --format iso --flake github:honzakostejn/koshos#x86_64-iso-image -o result

# todos
- [x] Control brightness with fn keys.
- [x] Control sound with fn keys.
- [ ] Enable hibernation with offset
- [ ] Display battery status.
- [ ] Setup firefox (ZEN) with extensions.
- [ ] Setup wallpaper with home-manager options.
- [ ] Configure nix-colors.
- [ ] Properly set hyprlock.
- [ ] Add hypridle.
- [ ] Customize AGS bar.
- [ ] Configure xremap to support macOS like bindings.
- [ ] Add binds to move the mouse to the hyprland.
- [ ] Enable TPM2 luks decrypt.

# sources
https://gitlab.com/hmajid2301/nixicle
https://github.com/fufexan/dotfiles/
https://github.com/Aylur/dotfiles