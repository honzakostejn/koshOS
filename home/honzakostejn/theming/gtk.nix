{
  pkgs,
  ...
}: {
  gtk = {
    enable = true;
    # already set with home.pointerCursor
    # cursorTheme = {
    #   name = "Bibata-Modern-Classic";
    #   package = pkgs.bibata-cursors;
    # };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };
}