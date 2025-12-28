{
  ...
}: {
  imports = [
    ../../../home/honzakostejn/programs/rclone
  ];

  home.stateVersion = "26.05";

  # info about user and path it manages
  home.username = "honzakostejn";
  home.homeDirectory = "/home/honzakostejn";

  # let Home Manager install and manage itself
  programs.home-manager.enable = true;
}