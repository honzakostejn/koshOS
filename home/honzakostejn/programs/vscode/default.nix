{ pkgs
, ...
}: {
  programs.vscode = {
    enable = true;
    # package = pkgs.vscode.fhs;
    extensions = with pkgs.vscode-extensions; [
      ms-dotnettools.csdevkit
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
      github.copilot
    ];
  };
}
