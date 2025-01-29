# 🗑️ koshOS
honzakostejn's dotfiles

# instructions
echo "password" > /tmp/secret.key # luks password
sudo nix run --extra-experimental-features "nix-command flakes" github:nix-community/disko#disko-install -- --flake github:honzakostejn/koshos#framework --write-efi-boot-entries --disk main /dev/nvme0n1
// boot into the OS
sudo nix run nixpkgs#sbctl create-keys
// enable lanzaboote
// enable secure boot
sudo nix run nixpkgs#sbctl enroll-keys -- --microsoft
sudo systemd-cryptenroll /dev/nvme0n1p2 --recovery-key
sudo systemd-cryptenroll /dev/nvme0n1p2 --tpm2-device=auto --tpm2-pcrs=0+2+7+12 --wipe-slot=tpm2

# hibernation
it might be required to reference disk by uuid for hibernation to work; then you can revert.

# useful commands
nix run nixpkgs#nixos-generators -- --format iso --flake github:honzakostejn/koshos#x86_64-iso-image -o result

# todos
- [x] Control brightness with fn keys.
- [x] Control sound with fn keys.
- [x] Enable hibernation with offset.
- [x] Configure Hyprland.
- [x] Display battery status.
- [ ] Setup firefox (ZEN) with extensions.
- [x] Setup wallpaper with home-manager options.
- [ ] Configure nix-colors.
- [ ] Properly set hyprlock.
- [x] Add hypridle.
- [ ] Customize AGS bar.
- [ ] kanata mods
- [ ] Add binds to move the mouse to the hyprland.
- [x] Enable TPM2 luks decrypt.
- [ ] optimize battery charging thresholds
- [ ] starship prompt
- [ ] tmux
- [ ] neorg

# sources
https://github.com/fufexan/dotfiles/
https://github.com/Aylur/dotfiles/
https://github.com/matt1432/nixos-configs/


https://haseebmajid.dev/posts/2024-07-30-how-i-setup-btrfs-and-luks-on-nixos-using-disko/
https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/
