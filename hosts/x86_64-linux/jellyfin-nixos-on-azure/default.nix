{ inputs
, modulesPath
, pkgs
, ...
}: {
  imports = [
    "${modulesPath}/virtualisation/azure-image.nix"

    ./jellyfin.nix
    ./networking.nix

    # make home-manager as a module of nixos
    # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.honzakostejn = import ./home.nix;
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
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
      # (builtins.readFile ~/.ssh/id_ed25519.pub)
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQQyWy4iYbl9eifEfPJ7krH7p7jELm9TcSKBuDJHckH kostejn@me.com"
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

  services.logrotate.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];
}