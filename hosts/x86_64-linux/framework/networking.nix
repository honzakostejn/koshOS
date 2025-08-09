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
      userServices = true;
      domain = true;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8010 # VLC streaming
      8080 # VLC remote playback

      # AirPlay
      7100
      7000
      7001
    ];
    allowedUDPPorts = [
      5353 # mDNS

      # AirPlay
      6000
      6001
      7011
    ];
  };
}
