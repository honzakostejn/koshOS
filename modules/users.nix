{
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
}