{ inputs
, lib
, pkgs
, config
, ...
}:
let
  winappsPackage = inputs.winapps.packages."${pkgs.system}".winapps.overrideAttrs (oldAttrs: {
    postUnpack = (oldAttrs.postUnpack or "") + ''
      cp ${./bin/winapps} $sourceRoot/bin/winapps
    '';
  });
in
{

  options = {
    koshos.home.honzakostejn.programs.winapps = {
      enable = lib.mkEnableOption "WinApps user configuration" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.winapps.enable {
    home.packages = [
      winappsPackage
    ];

    dconf.settings = {
      # https://github.com/winapps-org/winapps/blob/main/docs/libvirt.md#prerequisites
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };

    # Create WinApps configuration file
    xdg.configFile."winapps/winapps.conf".source = ./winapps.conf;

    # Run the installation script https://github.com/winapps-org/winapps/tree/main?tab=readme-ov-file#step-5-run-the-winapps-installer

    xdg.desktopEntries = {
      "Garmin Expressss" = {
        name = "Garmin Express";
        genericName = "Garmin Express";
        exec = "winapps manual express";
      };
    };

    xdg.desktopEntries = {
      "Visual Studio Code" = {
        name = "Visual Studio Code [Windows Edition]";
        genericName = "Visual Studio Code running on Windows via WinApps";
        exec = "winapps manual code";
      };
    };
  };
}
