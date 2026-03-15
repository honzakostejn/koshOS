{
  # Networking configuration for Raspberry Pi CM4 (handkerchief)
  networking = {
    hostName = "handkerchief";

    # Enable wireless support
    wireless = {
      enable = true; # Using NetworkManager instead
      networks."NETWORG".psk = "networg2019";
      networks."svarta_jump_official".psk = "toJUMPOVAL@666";
    };

    # Firewall configuration
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # SSH
        80 # HTTP
        443 # HTTPS
      ];
      allowedUDPPorts = [ ];
    };

    # Enable IPv6
    enableIPv6 = true;

    useDHCP = true;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.KbdInteractiveAuthentication = false;
  };
}
