# Jellyfin NixOS on Azure
This configuration sets up a NixOS system optimized for running Jellyfin on Microsoft Azure.

## How to deploy
1. If there's no ed25519 SSH key at `~/.ssh/id_ed25519.pub`, generate one with `ssh-keygen -t ed25519`.
2. Make sure the `openssh.authorizedKeys.keys` option in `hosts/x86_64-linux/jellyfin-nixos-on-azure/default.nix` contains your public SSH key.
3. Run `nix develop` to enter the development shell with Azure CLI installed.
4. Run `az login` to authenticate with your Azure account.
5. Upload the disk image to azure with `./hosts/x86_64-linux/jellyfin-nixos-on-azure/upload-image.sh --resource-group kosh --image-name jellyfin-nixos`.
6. Create the VM from the uploaded image with `./hosts/x86_64-linux/jellyfin-nixos-on-azure/boot-vm.sh --resource-group kosh --image jellyfin-nixos --vm-name jellyfin-nixos`.