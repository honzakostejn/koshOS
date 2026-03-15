{ pkgs
, lib
, config
, ...
}: {
  imports = [
    ./programs
  ];

  options.koshos.username = lib.mkOption {
    type = lib.types.str;
    default = "honzakostejn";
    description = "The home manager username.";
  };

  config = {
    home.stateVersion = "26.05";

    home.username = lib.mkDefault config.koshos.username;
    home.homeDirectory = lib.mkDefault "/home/${config.koshos.username}";

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      git
      btop
      cbonsai
      pandoc
      jellyfin-tui
      uv
      android-tools
    ];
  };
}
