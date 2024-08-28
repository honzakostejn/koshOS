{
  pkgs,
  ...
}: {
  fonts = {
    packages = with pkgs; [
      # serif fonts
      (google-fonts.override {fonts = ["Crimson Text" ];})

      # sans-serif fonts
      (google-fonts.override {fonts = [ "Public Sans" ];})

      # monospace fonts
      jetbrains-mono

      # emoji fonts
      openmoji-color

      # nerdfonts
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];

    # user defined fonts
    fontconfig.defaultFonts = {
      serif = [ "Crimson Text" "Symbols Nerd Font" ];
      sansSerif = [ "Pulic Sans" "Symbols Nerd Font" ];
      monospace = [ "JetBrains Mono" "Symbols Nerd Font" ];
      emoji = [ "OpenMoji Color" ];
    };
  };
}