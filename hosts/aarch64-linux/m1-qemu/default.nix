{
  ...
}: {
  imports = [
    # include the results of the hardware scan
    ./hardware-configuration.nix

    # disks configuration
    ./disks.nix

    # networking configuration
    ./networking.nix

    ../../../modules

    # ./environment.nix
    # ./security.nix
    # ../../look/fonts.nix
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      efiSupport = true;
      #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
      device = "nodev";
    };
  };

  system.stateVersion = "24.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
  };

  services.xserver.libinput.enable = true;
  services.libinput.touchpad.naturalScrolling = true;

  # video and audio routing
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # PulseAudio uses this RealTimeKit service to acquire real-time scheduling priority
  security.rtkit.enable = true;

  # other services
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  services.openssh.enable = true;
 
  # automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # miscellaneous
  security = {
    # allow wayland lockers to unlock the screen
    pam.services.hyprlock.text = "auth include login";
  };
}
