{ config
, lib
, pkgs
, inputs
, ...
}:
{
  system.stateVersion = "24.05";

  environment.packages = with pkgs; [
  ];

  environment.etcBackupExtension = ".bak";

  # android-integration.termux-open.enable = true;
  # android-integration.termux-open-url.enable = true;
  # android-integration.xdg-open.enable = true;

  time.timeZone = "Europe/Prague";

  user = {
    shell = "${pkgs.nushell}/bin/nushell";
  };

  home-manager = {
    config = import ./home.nix;
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
  };

  android-integration.termux-wake-lock.enable = true;
  android-integration.termux-wake-unlock.enable = true;
  android-integration.termux-reload-settings.enable = true;
  android-integration.termux-setup-storage.enable = true;
}
