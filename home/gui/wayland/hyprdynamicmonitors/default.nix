{
  self,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    self.homeModules.hyprdynamicmonitors
  ];

  home.packages = [
      inputs.hyprdynamicmonitors.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    home.hyprdynamicmonitors = {
      enable = true;
      configFile = ./config.toml;

      # Install the hyprconfigs files inline (no separate files in the repo)
      extraFiles = {
        "hyprdynamicmonitors/hyprconfigs" = ./hyprconfigs;
        
        # "hyprdynamicmonitors/hyprconfigs/undocked.conf" = pkgs.writeText "undocked.conf" ''
        #   monitor=eDP-1,preferred,auto,1.333
        # '';

        # "hyprdynamicmonitors/hyprconfigs/docked-hub-prague.conf" =
        #   pkgs.writeText "docked-hub-prague.conf" ''
        #     # docked-hub-prague: three externals + eDP-1 disabled
        #     monitor=,preferred,auto,1
        #     monitor=DP-1,preferred,auto,1,transform=90,position=0x0
        #     monitor=DP-2,preferred,auto,1,position=1200x0
        #     monitor=DP-3,preferred,auto,1,transform=270,position=3120x0
        #     # disable eDP-1
        #     monitor=eDP-1,disable
        #   '';

        # "hyprdynamicmonitors/hyprconfigs/docked-home.conf" = pkgs.writeText "docked-home.conf" ''
        #   # docked-home: single 4k external, scale 1.6, eDP-1 disabled
        #   monitor=,preferred,auto,1
        #   monitor=DP-1,preferred,3840x2160@60,0x0,1.6
        #   monitor=eDP-1,disable
        # '';

        # "hyprdynamicmonitors/hyprconfigs/docked-hub-sarajevo.conf" =
        #   pkgs.writeText "docked-hub-sarajevo.conf" ''
        #     # docked-hub-sarajevo: single external
        #     monitor=,preferred,auto,1
        #     monitor=DP-1,preferred,auto,1
        #     monitor=eDP-1,disable
        #   '';

        # "hyprdynamicmonitors/hyprconfigs/docked-hub-brno.conf" = pkgs.writeText "docked-hub-brno.conf" ''
        #   # docked-hub-brno: two externals + positioned eDP-1
        #   monitor=,preferred,auto,1
        #   monitor=DP-1,preferred,auto,1,position=0x0
        #   monitor=DP-2,preferred,auto,1,position=1920x0
        #   monitor=eDP-1,preferred,auto,1,position=960x1200
        # '';

        # "hyprdynamicmonitors/hyprconfigs/docked-hub-cetin.conf" = pkgs.writeText "docked-hub-cetin.conf" ''
        #   # docked-hub-cetin: two externals side-by-side, eDP-1 disabled
        #   monitor=,preferred,auto,1
        #   monitor=DP-1,preferred,auto,1,position=0x0
        #   monitor=DP-2,preferred,auto,1,position=1920x0
        #   monitor=eDP-1,disable
        # '';

        # "hyprdynamicmonitors/hyprconfigs/fallback.conf" = pkgs.writeText "fallback.conf" ''
        #   # fallback: generic config that sets connected monitors to preferred
        #   monitor=,preferred,auto,1
        # '';
      };
    };

    wayland.windowManager.hyprland.extraConfig = ''
      # source the auto-generated monitors configuration
      source = ~/.config/hypr/monitors.conf
    '';
}
