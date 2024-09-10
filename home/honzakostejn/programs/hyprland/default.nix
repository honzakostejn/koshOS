{
  ...
}: let
  # cursor = "Bibata-Modern-Classic-Hyprcursor";
  # cursorPackage = inputs.self.packages.${pkgs.system}.bibata-hyprcursor;
  
in {
  imports = [
    ./settings.nix
  ];

  # xdg.dataFile."icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";

  wayland.windowManager.hyprland = {
    enable = false;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
  };
}