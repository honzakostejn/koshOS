{ pkgs
, lib
, ...
}: {
  imports = [
    # hardware
    ./hardware-configuration.nix

    # disks configuration
    ./disks.nix

    # networking configuration
    ./networking.nix

    ./power.nix
    ./lanzaboote.nix

    ../../../modules

    # ./environment.nix
    # ./security.nix
    # ../../look/fonts.nix
  ];

  boot = {
    bootspec.enable = true;

    initrd = {
      systemd = {
        enable = true;
        tpm2.enable = true;
      };
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    # enable hibernation
    resumeDevice = "/dev/disk/by-label/nixos";
    kernelParams = [
      # https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
      "resume_offset=533760"
    ];
  };

  # enable TPM2 and PKCS#11
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
    tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  };

  system.stateVersion = "24.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
  };
  # required for AX210 wireless card
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    input = {
      General = {
        UserspaceHID = true;
      };
    };
    settings = {
      General = {
        Experimental = true; # show battery
        Enable = "Source,Sink,Media,Socket";

        # # https://www.reddit.com/r/NixOS/comments/1ch5d2p/comment/lkbabax/
        # # for pairing bluetooth controller
        # Privacy = "device";
        # JustWorksRepairing = "always";
        # Class = "0x000100";
        # FastConnectable = true;
      };
    };
  };
  hardware.xpadneo.enable = true; # Enable the xpadneo driver for Xbox One wireless controllers

  services.udev.packages = with pkgs; [ oversteer ];

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
  services.blueman.enable = true;
  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [
    seahorse

    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
  ];

  services.spice-vdagentd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };
  services.usbmuxd.enable = true;

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

    # don't ask for password for wheel group
    sudo.wheelNeedsPassword = false;
  };
}
