{
  ...
}: {
  imports = [
    # localization configuration
    ./localization.nix

    # environment configuration
    ./environment.nix

    # users configuration
    ./users.nix

    # look
    ./fonts.nix

    ../services
  ];
}