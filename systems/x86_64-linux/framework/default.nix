{
  ...
}: {
  imports = [
    # hardware
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
      device = "nodev";
    };

    # enable hibernation
    resumeDevice = "/dev/disk/by-label/nixos";
    kernelParams = [
      # https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
      "resume_offset=111111"
    ];
  };

  # enable TPM2 and PKCS#11
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
    tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  };

  system.stateVersion = "24.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
  };


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
  services.openssh.enable = true;
  services.fwupd.enable = true; # enable firmware updates daemon
  services.libinput.touchpad.naturalScrolling = true;
 
  # automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # miscellaneous
  security = {
    # allow wayland lockers to unlock the screen
    pam.services.hyprlock.text = "auth include login";
  };
}
