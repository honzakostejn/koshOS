{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # make home-manager as a module of nixos
    # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.honzakostejn = import ../home/honzakostejn;
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
  ];

  # define a user account
  # don't forget to set a password with ‘passwd’
  users.users.honzakostejn = {
    isNormalUser = true;
    description = "honzakostejn";
    initialPassword = "changemewithpasswd";
    extraGroups = [
      "audio"
      "networkmanager"
      "wheel"
      "tss" # tss group has access to TPM devices
    ];
  };

  # authentication daemon
  services.greetd = let
    session = {
      # this logs the user in automatically,
      # because there's no greeter specified in the command
      command = "${lib.getExe config.programs.hyprland.package}";
      user = "honzakostejn";
    };
  in {
    enable = true;
    settings = {
      default_session = session;
    };
  };

  # steam
  programs.steam = {
    enable = true;  # there is no aarch64 steam client
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
  programs.dconf.enable = true;
}