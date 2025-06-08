{
  # Networking configuration for Raspberry Pi CM4 (handkerchief)
  networking = {
    hostName = "handkerchief";
    
    # Use NetworkManager for easier wireless configuration
    networkmanager = {
      enable = true;
      wifi.powersave = false; # Disable WiFi power saving for better performance
    };
    
    # Enable wireless support
    wireless = {
      enable = false; # Using NetworkManager instead
    };
    
    # Firewall configuration
    firewall = {
      enable = true;
      allowedTCPPorts = [ 
        22    # SSH
        80    # HTTP
        443   # HTTPS
      ];
      allowedUDPPorts = [ ];
    };
    
    # Enable IPv6
    enableIPv6 = true;
    
    # Use systemd-resolved for DNS
    useNetworkd = false;
  };
  
  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  
  # Enable WiFi firmware
  hardware.enableRedistributableFirmware = true;
  
  # Optimize network performance for Raspberry Pi
  # boot.kernel.sysctl = {
  #   "net.core.rmem_default" = 31457280;
  #   "net.core.rmem_max" = 134217728;
  #   "net.core.wmem_default" = 31457280;
  #   "net.core.wmem_max" = 134217728;
  #   "net.core.netdev_max_backlog" = 5000;
  #   "net.ipv4.tcp_congestion_control" = "bbr";
  # };
}
