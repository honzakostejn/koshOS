{ inputs
, lib
, config
, pkgs
, ...
}: {
  options = {
    koshos.users.honzakostejn = {
      enable = lib.mkEnableOption "honzakostejn's user profile" // { default = true; };
    };
  };

  imports = [
    # make home-manager as a module of nixos
    # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.honzakostejn = import ../../../home/honzakostejn;
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
  ];

  config = lib.mkIf config.koshos.users.honzakostejn.enable {
    # don't forget to set a password with ‘passwd’
    users.users.honzakostejn = {
      isNormalUser = true;
      description = "honzakostejn";
      initialPassword = "changemewithpasswd";
      extraGroups = [
        "wheel" # allow the user to run sudo
        "audio"
        "video" # required for brillo and setting the brightness
        "networkmanager"
        "tss" # tss group has access to TPM devices
        "docker"
        "wireshark"
      ];

      shell = pkgs.nushell;
    };
  };
}
