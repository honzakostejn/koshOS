{ lib
, config
, pkgs
, inputs
, ...
}: {
  options = {
    home.honzakostejn.programs.ags = {
      enable = lib.mkEnableOption "AGS (Aylur's GTK Shell)" // { default = true; };
    };
  };

  imports = [ inputs.ags.homeManagerModules.default ];

  config = lib.mkIf config.home.honzakostejn.programs.ags.enable {

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
    #   Unit = {  #     Description = "Aylur's Gtk Shell";
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
  };
}
