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

        github.copilot
        github.copilot-chat
      ];

      # >> don't forget to set the password-store for the keyring to work <<
      # https://github.com/microsoft/vscode-docs/blob/vnext/docs/editor/settings-sync.md#recommended-configure-the-keyring-to-use-with-vs-code
      # Preferences: Configure Runtime Arguments command.
      # This will open the argv.json file where you can add the setting "password-store":"gnome-libsecret"
    };

    home.packages = with pkgs; [
      nixpkgs-fmt
    ];
  };
}
