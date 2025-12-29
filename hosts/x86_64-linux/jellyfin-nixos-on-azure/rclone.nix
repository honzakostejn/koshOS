{
  pkgs
  , ...
}: {
  environment.systemPackages = [ pkgs.rclone ];
  environment.etc."rclone-mnt.conf".text = ''
    [kosh-jellyfin]
    type = azureblob
    sas_url = agenix-or-sops
  '';

  fileSystems."/mnt" = {
    device = "kosh-jellyfin:jellyfin";
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "allow_other"
      "args2env"
      "config=/etc/rclone-mnt.conf"
    ];
  };
}
