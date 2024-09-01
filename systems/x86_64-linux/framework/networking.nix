{
  ...
}: {
  # enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "kosh-framework";

  # publish the hostname on the local network
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };
}