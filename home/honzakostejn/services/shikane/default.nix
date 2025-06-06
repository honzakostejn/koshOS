{ lib
, config
, ...
}: {
  options = {
    home.honzakostejn.programs.shikane = {
      enable = lib.mkEnableOption "Shikane display configuration daemon" // { default = true; };
    };
  };

  config = lib.mkIf config.home.honzakostejn.programs.shikane.enable {
    services.shikane = {
      enable = true;
      settings = {
        profile = [
          {
            name = "undocked";
            output = [
              {
                match = "eDP-1";
                enable = true;
                scale = 1.333;
              }
            ];
          }
          {
            name = "docked-hub-prague";
            output = [
              {
                match = "eDP-1";
                enable = false;
              }
              {
                search = [ "s=7MT0167B2AEL" ];
                position = {
                  x = -1200;
                  y = 0;
                };
                transform = "90";
                enable = true;
              }
              {
                search = [ "s=CZ49310227" ];
                position = {
                  x = 0;
                  y = 0;
                };
                enable = true;
              }
              {
                search = [ "s=7MT0162411FL" ];
                position = {
                  x = 2560;
                  y = 0;
                };
                transform = "270";
                enable = true;
              }
            ];
          }
          {
            name = "docked-home";
            output = [
              {
                match = "eDP-1";
                enable = false;
              }
              {
                search = [ "s=0x0000D2C6" ];
                position = {
                  x = 0;
                  y = 0;
                };
                enable = true;
                mode = "3840x2160@60";
                scale = 1.600;
              }
            ];
          }
        ];
      };
      #       settings = {
      #   profile = [
      #     {
      #       name = "external-monitor-default";
      #       output = [
      #         {
      #           match = "eDP-1";
      #           enable = true;
      #         }
      #         {
      #           match = "HDMI-A-1";
      #           enable = true;
      #           position = {
      #             x = 1920;
      #             y = 0;
      #           };
      #         }
      #       ];
      #     }
      #     {
      #       name = "builtin-monitor-only";
      #       output = [
      #         {
      #           match = "eDP-1";
      #           enable = true;
      #         }
      #       ];
      #     }
      #   ];
      # }
      # config = ''
      #   [[profile]]
      #   name = "undocked"
      #   # exec = ["swww-daemon & swww img /home/honzakostejn/koshos/assets/wallpapers/forest-fire.gif --filter Nearest"]
      #     [[profile.output]]
      #     match = "eDP-1"
      #     enable = true
      #     scale = 1.333

      #   [[profile]]
      #   name = "docked-hub-prague"
      #   # exec = ["swww-daemon & swww img /home/honzakostejn/koshos/assets/wallpapers/forest-fire.gif --filter Nearest"]
      #     [[profile.output]]
      #     match = "eDP-1"
      #     enable = false

      #     [[profile.output]]
      #     search = [ "s=7MT0167B2AEL" ]
      #     position = "-1200,0"
      #     transform = "90"
      #     enable = true

      #     [[profile.output]]
      #     search = [ "s=CZ49310227" ]
      #     position = "0,0"
      #     enable = true
        
      #     [[profile.output]]
      #     search = [ "s=7MT0162411FL" ]
      #     position = "2560,0"
      #     transform = "270"
      #     enable = true

      #   [[profile]]
      #   name = "docked-home"
      #     [[profile.output]]
      #     match = "eDP-1"
      #     enable = false

      #     [[profile.output]]
      #     search = [ "s=0x0000D2C6" ]
      #     position = "0,0"
      #     enable = true
      #     mode = "3840x2160@60"
      #     scale = 1.600
      # '';
    };
  };
}
