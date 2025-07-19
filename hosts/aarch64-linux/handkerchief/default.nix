{ pkgs
, modulesPath
, config
, lib
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    # ./disks.nix
    ./networking.nix
    # ./repart.nix

    "${modulesPath}/installer/sd-card/sd-image.nix"

    ../../../system
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.consoleLogLevel = lib.mkDefault 7;

  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  # https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  sdImage = {
    imageBaseName = "image-handkerchief";
    compressImage = false;
    populateFirmwareCommands = ''
      (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)

      # Add the config
      cp ${(./. + "/reTerminal-esp-contents/config.txt")} firmware/config.txt

      # Add cm4 specific files
      cp ${pkgs.ubootRaspberryPi4_64bit}/u-boot.bin firmware/u-boot-rpi4.bin
      cp ${pkgs.raspberrypi-armstubs}/armstub8-gic.bin firmware/armstub8-gic.bin
      cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-cm4.dtb firmware/
      cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-cm4s.dtb firmware/

      # Overlays
      # cp --recursive ${pkgs.raspberrypifw}/share/raspberrypi/boot/overlays firmware/overlays
      cp --recursive ${(./. + "/reTerminal-esp-contents/overlays")} firmware/overlays
    '';
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };

  systemd.services.shutdown = {
    description = "automatic shutdown";
    script = ''
      systemctl poweroff
    '';
  };
  systemd.timers.shutdown = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnUnitActiveSec = "1m";
    timerConfig.OnBootSec = "1m";
  };

  koshos.programs.steam.enable = false;
  home-manager.users.honzakostejn.koshos.programs.qutebrowser.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.hostPlatform = "aarch64-linux";
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
