{ config
, pkgs
, inputs
, ...
}: {
  imports = [ inputs.agsV2.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    configDir = ./.;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      inputs.agsV2.packages.${pkgs.system}.battery
      inputs.agsV2.packages.${pkgs.system}.hyprland
    ];
  };

  systemd.user.services.ags = {
    Unit = {
      Description = "Aylur's Gtk Shell";
      PartOf = [
        "graphical-session.target"
      ];
    };
    Service = {
      # ExecStart = "${inputs.agsV2.packages.${pkgs.system}.default}/bin/ags";
      ExecStart = "${config.programs.ags.finalPackage}/bin/ags";
      Restart = "on-failure";
    };
    Install.WantedBy = [
      "graphical-session.target"
    ];
  };
}
