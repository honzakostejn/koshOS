{ lib
, config
, pkgs
, ...
}: {
  options = {
    koshos.home.honzakostejn.programs.vscode = {
      enable = lib.mkEnableOption "Visual Studio Code editor" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.vscode.enable {
    programs.vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        yzhang.markdown-all-in-one
        jnoortheen.nix-ide
        streetsidesoftware.code-spell-checker
        # streetsidesoftware.code-spell-checker-czech

        github.copilot
        github.copilot-chat
      ];
    };

    home.packages = with pkgs; [
      nixpkgs-fmt
    ];
  };
}
