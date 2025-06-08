{ ...
}: {
  # enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "kosh-framework";

  # publish the hostname on the local network
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8010 # VLC streaming
      8080 # VLC remote playback
    ];
  };
}
