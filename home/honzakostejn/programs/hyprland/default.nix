{ inputs
, pkgs
, ...
}:
let
  # cursor = "Bibata-Modern-Classic-Hyprcursor";
  # cursorPackage = inputs.self.packages.${pkgs.system}.bibata-hyprcursor;

in
{
  imports = [
    inputs.hyprland.homeManagerModules.default

    ./settings
    ./plugins

    # ./hyprpaper.nix
  ];

  # xdg.dataFile."icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
  };
}
