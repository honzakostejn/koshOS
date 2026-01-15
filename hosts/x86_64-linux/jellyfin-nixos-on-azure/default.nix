{ inputs
, modulesPath
, pkgs
, ...
}: {
  imports = [
    "${modulesPath}/virtualisation/azure-image.nix"

    ./jellyfin.nix
    ./networking.nix
    ./rclone.nix
    ./usenet.nix
  ];
  
  image.fileName = "jellyfin-nixos.vhd";
  virtualisation.azureImage.vmGeneration = "v2";
  virtualisation.diskSize = 16000;

  system.stateVersion = "26.05";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Prague";

  users.users."honzakostejn" = {
    isNormalUser = true;
    home = "/home/honzakostejn";
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      (builtins.readFile ~/.ssh/id_ed25519.pub)
    ];
    shell = pkgs.zsh;
  };

  nix.settings = {
    warn-dirty = false;
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["honzakostejn"];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  programs.zsh.enable = true;

  # enable rclone mount to be used by jellyfin
  programs.fuse.userAllowOther = true;

  services.logrotate.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];
}