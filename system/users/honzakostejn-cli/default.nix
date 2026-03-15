{
  inputs,
  self,
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    koshos.users.honzakostejn-cli = {
      enable = lib.mkEnableOption "honzakostejn's CLI-only user profile" // {
        default = true;
      };
    };
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.honzakostejn = {
        imports = [ self.homeModules.cli ];
      };
      home-manager.extraSpecialArgs = { inherit inputs self; };
    }
  ];

  config = lib.mkIf config.koshos.users."honzakostejn-cli".enable {
    # don't forget to set a password with 'passwd'
    users.users.honzakostejn = {
      isNormalUser = true;
      description = "honzakostejn";
      initialPassword = "changemewithpasswd";
      extraGroups = [
        "wheel" # allow the user to run sudo
        "networkmanager"
        "tss" # tss group has access to TPM devices
        "wireshark"
      ];

      shell = pkgs.nushell;
    };
  };
}
