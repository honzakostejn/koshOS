# 🗑️ koshOS
honzakostejn's dotfiles

# commands
sudo nix run github:nix-community/disko#disko-install -- --flake github:honzakostejn/koshos#m1-qemu --write-efi-boot-entries --disk main /dev/nvme1n1

nix run nixpkgs#nixos-generators -- --format iso --flake github:honzakostejn/koshos#x86_64-iso-image -o result

# sources
https://gitlab.com/hmajid2301/nixicle
https://github.com/fufexan/dotfiles/
https://github.com/Aylur/dotfiles