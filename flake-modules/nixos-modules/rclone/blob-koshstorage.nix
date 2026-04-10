{
  pkgs
  , ...
}: {
  environment.systemPackages = [ pkgs.rclone ];
  environment.etc."rclone-mnt.conf".text = ''
    [storageaccount]
    type = azureblob
    sas_url = donotcommitsecrets

    [decrypted-storageaccount]
    type = crypt
    remote = storageaccount:media
    password = donotcommitsecrets
  '';

  fileSystems."/mnt/media" = {
    device = "decrypted-storageaccount:";
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
