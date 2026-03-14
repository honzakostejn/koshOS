{ config, ... }: {
  flake.packages.x86_64-linux = {
    # aarch64 image cross-compiled from x86_64
    image-handkerchief = config.flake.nixosConfigurations.handkerchief.config.system.build.sdImage;
    image-jellyfin-nixos-on-azure =
      config.flake.nixosConfigurations.jellyfin-nixos-on-azure.config.system.build.azureImage;
    image-kosh-vm = config.flake.nixosConfigurations.kosh-vm.config.system.build.azureImage;
  };
}
