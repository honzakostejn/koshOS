{ pkgs
, ...
}: {
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
}
