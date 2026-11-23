# Jellyfin NixOS on Azure

This configuration sets up a NixOS system optimized for running Jellyfin on
Microsoft Azure.

## How to deploy

1. If there's no ed25519 SSH key at `~/.ssh/id_ed25519.pub`, generate one with
   `ssh-keygen -t ed25519`.
2. Make sure the `openssh.authorizedKeys.keys` option in
   `flake-modules/hosts/x86_64-linux/jellyfin-nixos-on-azure/configuration.nix`
   contains your public SSH key.
3. Run `nix develop` to enter the development shell with Azure CLI installed.
4. Run `az login` to authenticate with your Azure account.
5. Build and upload the disk image to Azure:
   ```
   ./scripts/upload-vhd-image-to-azure.sh \
     --flake-attr image-jellyfin-nixos-on-azure \
     --resource-group kosh \
     --image-name jellyfin-nixos
   ```
6. Create and boot the VM from the uploaded image:
   ```
   ./scripts/deploy-and-boot-azure-vm-from-image.sh \
     --resource-group kosh \
     --image jellyfin-nixos \
     --vm-name jellyfin-nixos
   ```
