{ inputs, self, ... }: {
  flake.nixosModules.users-honzakostejn = { pkgs, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.honzakostejn = {
          imports = [ self.homeModules.cli self.homeModules.gui ];
        };
        home-manager.extraSpecialArgs = { inherit inputs self; };
      }
    ];

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
        "wireshark"
      ];

      shell = pkgs.nushell;
    };
  };
}
