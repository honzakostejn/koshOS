{
  pkgs
  , ...
}:
let
  externalInterface =
    # "enp193s0f3u1u2";
    # "wlp1s0";
    "eth0";
  hostAddress = "192.168.100.1";
in
{
  # https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
  containers.usenet = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = hostAddress;
    localAddress = "192.168.100.11";

    config = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true; # NZBGet depends on unrar

      programs.zsh.enable = true;

      users.users.usenet = {
        home = "/home/usenet";
        isNormalUser = true;
      };
      
      services.nzbget = {
        enable = true;
        user = "usenet";
        settings = {
          # https://github.com/nzbgetcom/nzbget/blob/develop/nzbget.conf
          
          MainDir = "/home/usenet/nzbget";
          ControlUsername = "usenet";
          ControlPassword = "donotcommitsecrets";

          "Server1.Active" = true;
          "Server1.Name" = "hitnews";
          "Server1.Level" = 0;
          "Server1.Optional" = false;
          "Server1.Host" = "news.hitnews.com";
          "Server1.Encryption" = true;
          "Server1.Port" = 563;
          "Server1.Username" = "donotcommitsecrets";
          "Server1.Password" = "donotcommitsecrets";
          "Server1.JoinGroup" = false;
          "Server1.Connections" = 100;
          "Server1.Retention" = 0;
          "Server1.CertVerification" = "strict";
        };
      };

      services.sonarr = {
        enable = true;
        openFirewall = true;
        user = "usenet";
        dataDir = "/home/usenet/sonarr";
      };

      networking =
        let
          serverIp = "0.0.0.0";
          port = 00000;
        in
        {
          firewall = {
            # services.nzbget.openFirewall doesn't exist
            allowedTCPPorts = [ 6789 ];
          };

          # https://alberand.com/nixos-wireguard-vpn.html
          wg-quick.interfaces.wg0 = {
            autostart = true;
            address = [ 
              "0.0.0.0/32"
            ];
            dns = [ "0.0.0.0" ];
            privateKey = "donotcommitsecrets";
            peers = [
              {
                publicKey = "donotcommitsecrets";
                allowedIPs = [
                  "0.0.0.0/0"
                  "::/0"
                ];
                endpoint = "${serverIp}:${builtins.toString port}";
              }
            ];

            # kill switch
            postUp = ''
              # Mark packets on the wg0 interface
              wg set wg0 fwmark ${builtins.toString port}

              # Forbid anything else which doesn't go through wireguard VPN on
              # ipV4 and ipV6
              ${pkgs.iptables}/bin/iptables -A OUTPUT \
                ! -d 192.168.0.0/16 \
                ! -o wg0 \
                -m mark ! --mark $(wg show wg0 fwmark) \
                -m addrtype ! --dst-type LOCAL \
                -j REJECT
              ${pkgs.iptables}/bin/ip6tables -A OUTPUT \
                ! -o wg0 \
                -m mark ! --mark $(wg show wg0 fwmark) \
                -m addrtype ! --dst-type LOCAL \
                -j REJECT
            '';
            postDown = ''
              ${pkgs.iptables}/bin/iptables -D OUTPUT \
                ! -o wg0 \
                -m mark ! --mark $(wg show wg0 fwmark) \
                -m addrtype ! --dst-type LOCAL \
                -j REJECT
              ${pkgs.iptables}/bin/ip6tables -D OUTPUT \
                ! -o wg0 -m mark \
                ! --mark $(wg show wg0 fwmark) \
                -m addrtype ! --dst-type LOCAL \
                -j REJECT
            '';
          };

          interfaces."eth0".ipv4.routes = [
            {
              address = serverIp;
              prefixLength = 32;
              via = hostAddress;
            }
          ];
        };
    };

    bindMounts = {
      "/home/usenet/media" = {
        hostPath = "/mnt/media";
        isReadOnly = false;
      };
    };
  };

  networking = {
    # to allow container to access the internet
    nat = {
      enable = true;
      internalInterfaces = [ "ve-usenet" ];
      externalInterface = externalInterface;
    };
  };

  # prevent systemd-networkd from auto-assigning addresses to the container veth interface
  # if you're using NetworkManager, this is not necessary
  # Azure uses systemd-networkd (via cloud-init), which auto-configures interfaces
  # this causes extra IPs on ve-usenet that break routing when WireGuard is active in the container
  systemd.network.networks."40-ve-usenet" = {
    matchConfig.Name = "ve-usenet";
    linkConfig.Unmanaged = true;
  };
}