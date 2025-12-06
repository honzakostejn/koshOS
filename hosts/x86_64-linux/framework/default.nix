{ inputs
, pkgs
, lib
, ...
}: {
  imports = [
    ./disks.nix
    ./environment.nix
    ./hardware-configuration.nix
    ./lanzaboote.nix
    ./localization.nix
    ./networking.nix
    ./power.nix

    ../../../system
  ];

  boot = {
    bootspec.enable = true;

    binfmt.emulatedSystems = [ "aarch64-linux" ];

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

    # https://wiki.nixos.org/wiki/PipeWire#AirPlay/RAOP_configuration
    # opens UDP ports 6001-6002
    raopOpenFirewall = true;
    extraConfig.pipewire = {
      # "10-airplay" = {
      #   "context.modules" = [
      #     {
      #       name = "libpipewire-module-raop-discover";

      #       # increase the buffer size if you get dropouts/glitches
      #       # args = {
      #       #   "raop.latency.ms" = 500;
      #       # };
      #     }
      #   ];
      # };
    };
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
  services.usbmuxd.enable = true;

  # automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # miscellaneous
  security = {
    polkit.enable = true;

    # allow wayland lockers to unlock the screen
    pam.services.hyprlock.text = "auth include login";
    # https://discourse.nixos.org/t/unable-to-fix-too-many-open-files-error/27094/10
    pam.loginLimits = [
      { domain = "*"; type = "soft"; item = "nofile"; value = "65536"; }
      { domain = "*"; type = "hard"; item = "nofile"; value = "1048576"; }
    ];

    # don't ask for password for wheel group
    sudo.wheelNeedsPassword = false;
  };

  # screen sharing
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # programs.kdeconnect.enable = true;
  programs.bash.enable = true;

  koshos = {
    programs.waydroid.enable = true;
  };

  # fingerprint reader
  # don't forget to enroll your fingerprint
  # sudo fprintd-enroll $USER
  services.fprintd.enable = true;
}
