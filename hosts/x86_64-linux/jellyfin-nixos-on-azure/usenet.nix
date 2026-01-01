{
  pkgs
  , ...
}: {
  networking.firewall.allowedTCPPorts = [ 6789 ]; # NZBGet
  # networking.firewall.trustedInterfaces = [ "ve-usenet" ];
  # networking.nat.enable = true;
  # networking.nat.internalInterfaces = [ "ve-usenet" ];
  # networking.networkmanager.unmanaged = [ "interface-name:ve-usenet" ];
  # networking.nat.externalInterface = "eth0";

  containers.usenet = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.1";
    localAddress = "192.168.100.11";

    # forwardPorts = [
    #   { hostPort = 6789; containerPort = 6789; protocol = "tcp"; }
    # ];

    config = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true; # NZBGet depends on unrar
      
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 6789 ];
      };

      programs.zsh.enable = true;
      services.nzbget = {
        enable = true;
        settings = {
          MainDir = "/mnt/media";
        };
      };

      # networking.firewall.enable = true;
      # networking.firewall.allowedTCPPorts = [ 6789 ];

      # networking.wg-quick.interfaces = {
      #   wg0 = {
      #     autostart = true;
      #     address = [ 
      #       "10.2.0.2/32"
      #     ];
      #     dns = [ "10.2.0.1" ];
      #     privateKeyFile = "privatekeyhere";
      #     peers = [
      #       {
      #         publicKey = "publickeyhere";
      #         allowedIPs = [
      #           "0.0.0.0/0"
      #           "::/0"
      #         ];
      #         endpoint = "149.34.251.134:51820";
      #       }
      #     ];
      #     postUp = ''iptables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT'';
      #     preDown = ''iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT'';
      #   };
      # };

      # # debug info
      # systemd.services.print-ip-after-boot = {
      #   after = [ "network-online.target" ];
      #   wantedBy = [ "multi-user.target" ];
      #   serviceConfig = {
      #     Type = "oneshot";
      #     ExecStart = "curl -s https://api.ipify.org > /mnt/media/ip-after-boot.txt";
      #   };
      # };
      # systemd.services.print-ip-after-60-seconds = {
      #   after = [ "network-online.target" ];
      #   wantedBy = [ "multi-user.target" ];
      #   serviceConfig = {
      #     Type = "oneshot";
      #     ExecStart = "${pkgs.coreutils}/bin/sleep 60 && curl -s https://api.ipify.org > /mnt/media/ip-after-60-seconds.txt";
      #   };
      # };
    };

    bindMounts = {
      "/mnt/media" = {
        hostPath = "/mnt/media";
      };
    };
  };
}