{
  pkgs,
  ...
}: {
  # enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "kosh-framework";

  # publish the hostname on the local network
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
      domain = true;
    };
  };

  # enable printing discovery
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
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

    # KDE Connect ports
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  };
}
