{ ... }: {
  flake.nixosModules.services-kanata = { ... }: {
    services.kanata = {
      enable = true;

      keyboards = {
        # you can find the connected keyboard by running:
        # ls -l /dev/input/by-id

        framework = {
          devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
          config = builtins.readFile ./kanata.kbd;
        };

        keychron-k6 = {
          devices = [ "/dev/input/by-id/usb-Keychron_Keychron_K6-event-kbd" ];
          config = builtins.readFile ./kanata.kbd;
        };

        keychron-k6-bt = {
          devices = [ "/dev/input/event20" ];
          config = builtins.readFile ./kanata.kbd;
          # extraDefCfg = ''
          #   ;; because of BT, use the linux-dev-names-include
          #   ;; https://jtroo.github.io/config.html#linux-only-linux-dev-names-include
          #   linux-dev-names-include ("Keychron K6")
          # '';
        };

        logitech = {
          devices = [ "/dev/input/by-id/usb-Logitech_USB_Keyboard-event-kbd" ];
          config = builtins.readFile ./kanata.kbd;
        };

        lenovo = {
          devices = [ "/dev/input/by-id/usb-LiteOn_Lenovo_Calliope_USB_Keyboard-event-kbd" ];
          config = builtins.readFile ./kanata.kbd;
        };

        dell = {
          devices = [ "/dev/input/by-id/usb-Dell_Dell_Wired_Multimedia_Keyboard-event-kbd" ];
          config = builtins.readFile ./kanata.kbd;
        };

        dell2 = {
          devices = [ "/dev/input/by-id/usb-413c_Dell_KB216_Wired_Keyboard-event-kbd" ];
          config = builtins.readFile ./kanata.kbd;
        };
      };
    };
  };
}
