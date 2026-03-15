{ ... }: {
  flake.nixosModules.programs-docker = { ... }: {
    users.groups.docker.members = [ "honzakostejn" ];

    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };
}
