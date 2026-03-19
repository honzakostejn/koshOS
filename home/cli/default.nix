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
      gh
      git-credential-manager
      btop
      cbonsai
      pandoc
      jellyfin-tui
      uv
      android-tools
    ];

    home.sessionVariables = {
      # https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/credstores.md#freedesktoporg-secret-service-api
      GCM_CREDENTIAL_STORE = "secretservice";
    };
  };
}
