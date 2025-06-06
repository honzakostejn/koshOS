{
  inputs,
  ...
}: {
  imports = [
    # Raspberry Pi CM4 hardware configuration
    ./hardware-configuration.nix
    
    # Disko configuration for 32GB eMMC with btrfs
    ./disks.nix
    
    # Networking configuration
    ./networking.nix
  ];

  # Raspberry Pi CM4 specific configuration
  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  hardware = {
    deviceTree = {
      enable = true;
      filter = "bcm2711-rpi-cm4.dtb";
    };

    raspberry-pi."4" = {
      audio.enable = true;
      fkms-3d.enable = true;
      apply-overlays-dtmerge.enable = true;
    };
  };
  
  # Configure for eMMC boot
  # boot.kernelParams = [
  #   "console=serial0,115200"
  #   "console=tty1"
  #   "rootfstype=btrfs"
  # ];

  # System configuration
  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-linux";

  # Enable hardware acceleration
  hardware.graphics = {
    enable = true;
  };

  # Enable SSH for remote access
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.KbdInteractiveAuthentication = false;
  };

  # # Audio support
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  # };
  
  # # Enable real-time kit for audio
  # security.rtkit.enable = true;

  # Enable I2C, SPI, and GPIO access
  hardware.i2c.enable = true;
  hardware.raspberry-pi."4".i2c1.enable = true;
  users.groups.gpio = {};
  services.udev.extraRules = ''
    SUBSYSTEM=="gpio", KERNEL=="gpiochip[0-9]*", ACTION=="add", PROGRAM="/bin/sh -c 'chown root:gpio /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
    SUBSYSTEM=="gpio", KERNEL=="gpio[0-9]*", ACTION=="add", PROGRAM="/bin/sh -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
  '';
}
