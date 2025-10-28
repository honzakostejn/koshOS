{ config
, lib
, pkgs
, inputs
, ...
}:
{
  system.stateVersion = "24.05";
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.etcBackupExtension = ".bak";

  # android-integration.termux-open.enable = true;
  # android-integration.termux-open-url.enable = true;
  # android-integration.xdg-open.enable = true;

  time.timeZone = "Europe/Prague";

  user = {
    shell = "${pkgs.nushell}/bin/nu";
  };

  home-manager = {
    config = import ./home.nix;
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
  };

  android-integration.termux-wake-lock.enable = true;
  android-integration.termux-wake-unlock.enable = true;
  android-integration.termux-reload-settings.enable = true;
  android-integration.termux-setup-storage.enable = true;

  terminal.font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
  terminal.colors = {
    # https://github.com/Iamafnan/termux-tokyonight/blob/main/colorschemes/tokyonight-night.properties
    foreground = "#c0caf5";
    cursor = "#c0caf5";
    background = "#1a1b26";
    color0 = "#15161E";
    color1 = "#f7768e";
    color2 = "#9ece6a";
    color3 = "#e0af68";
    color4 = "#7aa2f7";
    color5 = "#bb9af7";
    color6 = "#7dcfff";
    color7 = "#a9b1d6";
    color8 = "#414868";
    color9 = "#f7768e";
    color10 = "#9ece6a";
    color11 = "#e0af68";
    color12 = "#7aa2f7";
    color13 = "#bb9af7";
    color14 = "#7dcfff";
    color15 = "#c0caf5";
  };
}
