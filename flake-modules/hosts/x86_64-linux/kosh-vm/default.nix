{ inputs
, modulesPath
, pkgs
, ...
}: {
  imports = [
    "${modulesPath}/virtualisation/azure-image.nix"
  ];
  
  image.fileName = "kosh-vm.vhd";
  virtualisation.azureImage.vmGeneration = "v2";
  virtualisation.azure.acceleratedNetworking = true;
  virtualisation.diskSize = 16000;

  networking.hostName = "kosh-vm";
  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "26.05";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Prague";
  nixpkgs.config.allowUnfree = true;

  users.users."honzakostejn" = {
    # rest is defined in system nix module
    openssh.authorizedKeys.keys = [
      (builtins.readFile ~/.ssh/id_ed25519.pub)
    ];
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

  services.logrotate.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];
}