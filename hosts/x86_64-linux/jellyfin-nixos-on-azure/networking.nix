{
  ...
}: {
  networking.hostName = "jellyfin-nixos";
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;
    virtualHosts = {
      "stream.kosh.boo".extraConfig = ''
        reverse_proxy 127.0.0.1:8096
      '';
      "nzbget.kosh.boo".extraConfig = ''
        reverse_proxy 192.168.100.11:6789
      '';
      "radarr.kosh.boo".extraConfig = ''
        reverse_proxy 192.168.100.11:7878
      '';
      "sonarr.kosh.boo".extraConfig = ''
        reverse_proxy 192.168.100.11:8989
      '';
    };
  };  
}