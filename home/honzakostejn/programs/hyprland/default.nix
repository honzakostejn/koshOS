{ ...
}:
let
  # cursor = "Bibata-Modern-Classic-Hyprcursor";
  # cursorPackage = inputs.self.packages.${pkgs.system}.bibata-hyprcursor;

in
{
  imports = [
    ./settings
    ./plugins

    ./hyprpaper.nix
  ];

  # xdg.dataFile."icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
  };
}
