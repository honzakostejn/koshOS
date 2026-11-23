{ inputs
, pkgs
, ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  # upstream's nix/hashes.json is stale for this rev and does not match its node_modules output
  nodeModulesHash = {
    x86_64-linux = "sha256-sdMjb/l8SIthDbBJO3VzpyoOL9auoFGjVb6HdlxkQGg=";
  }.${system} or null;
  opencodePackage = inputs.opencode.packages.${system}.default;
  opencodeWithHash = opencodePackage.override {
    node_modules = pkgs.callPackage (inputs.opencode + "/nix/node_modules.nix") {
      rev = inputs.opencode.shortRev;
      hash = nodeModulesHash;
    };
  };
in
{
  home.packages = with pkgs; [
    # so that cli.attention.sound works
    libpulseaudio
    alsa-utils
  ];

  programs.opencode = {
    enable = true;
    package = if nodeModulesHash == null then opencodePackage else opencodeWithHash;
    cli = {
      attention = {
        notifications = false;
        sound = true;
        volume = 1.0;
      };
      theme = {
        name = "tokyonight";
      };
      diffs = {
       wrap = "word";
      };
      session = {
        sidebar = "auto";
        scrollbar = false;
        thinking = "hide";
      };
      animations = true;
    };
    # enableMcpIntegration = true;
    # settings = {
    #   theme = "tokyonight";
    #   agent = {
    #     # http://opencode.ai/docs/agents/#options
    #   };
    #   formatter = {
    #     # http://opencode.ai/docs/formatters/#custom-formatters
    #     nix = {
    #       extensions = [ ".nix" ];
    #       command = [
    #         "${pkgs.nixfmt-rfc-style}/bin/nixfmt"
    #         "$FILE"
    #       ];
    #     };
    #   };
    # };
  };

  # xdg.configFile."opencode" = {
  #   source = ./.;
  #   recursive = true;
  # };
}
