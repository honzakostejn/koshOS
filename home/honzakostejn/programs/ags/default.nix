{ config
, pkgs
, inputs
, ...
}: {
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    configDir = ./.;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      inputs.ags.packages.${pkgs.system}.battery
      inputs.ags.packages.${pkgs.system}.hyprland
    ];
  };

  # currently started from hyprland
  # systemd.user.services.ags = {
  #   Unit = {
  #     Description = "Aylur's Gtk Shell";
  #     PartOf = [
  #       "graphical-session.target"
  #     ];
  #   };
  #   Service = {
  #     # ExecStart = "${inputs.agsV2.packages.${pkgs.system}.default}/bin/ags";
  #     ExecStart = "${config.programs.ags.finalPackage}/bin/ags";
  #     Restart = "on-failure";
  #   };
  #   Install.WantedBy = [
  #     "graphical-session.target"
  #   ];
  # };
}
