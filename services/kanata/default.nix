{ ...
}: {
  # keyboard remapping
  services.kanata = {
    enable = true;

    keyboards = {
      default = {
        devices = [ ];
        config = builtins.readFile (./. + "/kanata.kbd");
      };

      # framework = {
      #   devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      #   config = builtins.readFile (./. + "/kanata.kbd");
      # };

      # keychron-k6 = {
      #   devices = [ "/dev/input/by-id/usb-Keychron_Keychron_K6-event-kbd" ];
      #   config = builtins.readFile (./. + "/kanata.kbd");
      # };
    };
  };
}
