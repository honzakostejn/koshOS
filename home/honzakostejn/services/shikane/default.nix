{ lib
, config
, ...
}: {
  options = {
    koshos.home.honzakostejn.programs.shikane = {
      enable = lib.mkEnableOption "Shikane display configuration daemon" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.shikane.enable {
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
          {
            name = "docked-hub-sarajevo";
            output = [
              {
                match = "eDP-1";
                enable = false;
              }
              {
                search = [ "s=GMXM8HA570389" ];
                enable = true;
              }
            ];
          }
        ];
      };
    };
  };
}
