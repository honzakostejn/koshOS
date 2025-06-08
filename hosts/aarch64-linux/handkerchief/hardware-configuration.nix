{ config
, lib
, pkgs
, inputs
, ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    # (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Raspberry Pi CM4 specific boot configuration
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "vc4"
    "bcm2835_dma"
    "i2c_bcm2835"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Kernel configuration for Raspberry Pi CM4
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;

  # Enable firmware
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = with pkgs; [ raspberrypifw ];

  # CPU configuration
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  # Networking interfaces
  networking.useDHCP = lib.mkDefault true;

  # Console configuration
  console = {
    earlySetup = true;
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Temperature monitoring
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];
}
