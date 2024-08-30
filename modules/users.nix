{
  config,
  lib,
  pkgs,
  ...
}: {
  # define a user account
  # don't forget to set a password with ‘passwd’
  users.users.honzakostejn = {
    isNormalUser = true;
    description = "honzakostejn";
    initialPassword = "changemewithpasswd";
    extraGroups = [ "networkmanager" "wheel" ];
  };

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
}