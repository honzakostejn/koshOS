{
  pkgs
  , ...
}: {
  containers.usenet = {
    autoStart = true;
    enableTun = true;
    privateNetwork = true;

    config = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true; # nzbget depends on unrar
      
      users.users.usenet = {
        isNormalUser = true;
        # extraGroups = ["wheel"];
        shell = pkgs.zsh;
      };

      programs.zsh.enable = true;
      services.nzbget.enable = true;
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 6789 ]; # NzbGet

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

    forwardPorts = [
      { containerPort = 6789; hostPort = 6789; protocol = "tcp"; } # NzbGet
    ];

    bindMounts = {
      "/mnt/media" = {
        hostPath = "/mnt/media";
      };
    };
  };
}