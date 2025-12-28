{ lib
, config
, pkgs
, ...
}: {
  options = {
    koshos.home.honzakostejn.programs.rclone = {
      enable = lib.mkEnableOption "rclone to manage files in cloud storage" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.rclone.enable {
    programs.rclone = {
      enable = true;
      remotes = {
        kosh-jellyfin = {
          config = {
            type = "azureblob";
            sas_url = "agenix/sops-nix";
          };
          mounts = {
            "" = {
              enable = true;
              mountPoint = "/home/honzakostejn/rclone";
              options = {
                dir-cache-time = "48h";
                poll-interval = "60s";
                umask = "002";
                dir-perm = "0770";
                file-perm = "0664";
                user-agent = "Laptop";
                allow-other = true;
              };
            };
          };
        };
      };
    };
  };
}
