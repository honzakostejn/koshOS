{ lib
, config
, ...
}: {
  options = {
    koshos.services.kanata = {
      enable = lib.mkEnableOption "kanata keyboard remapping service" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.services.kanata.enable {
    services.kanata = {
      enable = true;

      keyboards = {
        # remapping all keyboards by default was removed due to issues with some peripherals
        # default = {
        #   devices = [ ];
        #   config = builtins.readFile (./. + "/kanata.kbd");
        # };

        # you can find the connected keyboard by running:
        # ls -l /dev/input/by-id

        framework = {
          devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
          config = builtins.readFile (./. + "/kanata.kbd");
        };

        keychron-k6 = {
          devices = [ "/dev/input/by-id/usb-Keychron_Keychron_K6-event-kbd" ];
          config = builtins.readFile (./. + "/kanata.kbd");
        };

        logitech = {
          devices = [ "/dev/input/by-id/usb-Logitech_USB_Keyboard-event-kbd" ];
          config = builtins.readFile (./. + "/kanata.kbd");
        };
      };
    };
  };
}
