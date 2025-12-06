# 🗑️ koshOS
honzakostejn's dotfiles

# instructions
These are the instructions to deploy koshOS on a framework laptop with disk encryption, TPM2 and Secure Boot support.

1. Clone the repo.
2. Remove lanzaboote from the nix configuration.
3. Create a temporary LUKS password `echo "password" > /tmp/secret.key`.
4. Build and install the OS `sudo nix run --extra-experimental-features "nix-command flakes" github:nix-community/disko#disko-install -- --flake ~/koshos#framework --write-efi-boot-entries --disk main /dev/nvme0n1`.
5. Boot into the OS.
6. Create Secure Boot keys `sudo nix run nixpkgs#sbctl create-keys`.
7. Revert the lanzaboote removal in the nix configuration and rebuild the OS again.
8. Verify the Secure Boot setup `sudo sbctl verify` (it's expected the kernel is not signed yet).
9. Enter UEFI settings and erase all Secure Boot settings. *Administer Secure Boot* > *Erase all Secure Boot Settings* (this might differ based on the hardware).
10. Enroll Microsoft keys `sudo sbctl enroll-keys -- --microsoft`.
11. Enter UEFI settings and enable Secure Boot.
12. Verify Secure Boot status `bootctl status`.
13. Generate a LUKS recovery key and save it securely `sudo systemd-cryptenroll /dev/nvme0n1p2 --recovery-key`.
14. Remove the temporary LUKS password `sudo systemd-cryptenroll /dev/nvme0n1p2 --wipe-slot=0`.
15. Add TPM2 to LUKS `sudo systemd-cryptenroll /dev/nvme0n1p2 --tpm2-device=auto --tpm2-pcrs=0+2+7+12 --wipe-slot=tpm2`.

# fingerprint reader
sudo fprintd-enroll $USER

# vscode keyring
To enable the VS Code keyring, set the password store to "gnome-libsecret". Open Preferences → Configure Runtime Arguments to edit argv.json and add the setting "password-store": "gnome-libsecret"; see https://code.visualstudio.com/docs/configure/settings-sync#_recommended-configure-the-keyring-to-use-with-vs-code for details.

# bitwarden cli
https://bitwarden.com/blog/how-to-securely-store-your-secrets-manager-access-tokens-with-bash-scripting/#storing-access-tokens-with-linux-desktop

# fn lock
Fn + ESC

# git
git-credential-manager is already installed; just configure it:
```bash
git config --global credential.azreposCredentialType oauth
git-credential-manager configure
```

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
- [x] Setup firefox (ZEN) with extensions.
- [x] Setup wallpaper with home-manager options.
- [x] Add hypridle.
- [x] kanata mods
- [x] Add binds to move the mouse to the hyprland.
- [x] Enable TPM2 luks decrypt.
- [x] starship prompt
- [ ] optimize battery charging thresholds
- [ ] yazi + keymap
- [ ] Customize AGS bar.
- [ ] helix + keymap
- [ ] qutebrowser bitwarden script to search for everything
- [ ] zettlekasten
- [ ] Configure nix-colors.
- [ ] Properly set hyprlock.

# keyboard layout
- inspired by https://github.com/manna-harbour/miryoku

# sources
https://github.com/fufexan/dotfiles/
https://github.com/Aylur/dotfiles/
https://github.com/matt1432/nixos-configs/


https://github.com/KaiWalter/nixos-cloud-deploy


https://haseebmajid.dev/posts/2024-07-30-how-i-setup-btrfs-and-luks-on-nixos-using-disko/
https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/
