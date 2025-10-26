{ lib
, pkgs
, config
, ...
}:
{
  options = {
    koshos.programs.docker = {
      enable = lib.mkEnableOption "Docker" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.koshos.programs.docker.enable {
    users.groups.docker.members = [ "honzakostejn" ];

    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };
}
