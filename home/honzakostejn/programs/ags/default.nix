{
  pkgs,
  inputs,
  ...
}: let
  kosh-ags = pkgs.callPackage ../../../../pkgs/kosh-ags/default.nix {inherit inputs;};

in {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  programs.ags = {
    enable = true;
    configDir = "${kosh-ags}";
    extraPackages = import ../../../../pkgs/kosh-ags/dependencies.nix {inherit pkgs;};
  };
  
  systemd.user.services.ags = {
    Unit = {
      Description = "Aylur's Gtk Shell";
      PartOf = [
        "graphical-session.target"  # "hyprland-session.target"
      ];
    };
    Service = {
      ExecStart = "${inputs.ags.packages.${pkgs.system}.default}/bin/ags";
      Restart = "on-failure";
    };
    Install.WantedBy = [
      "graphical-session.target"  # "hyprland-session.target"
    ];
  };
}