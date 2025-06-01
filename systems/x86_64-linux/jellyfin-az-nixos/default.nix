{ inputs
, ...
}: {
  imports = [
    ./disks.nix
    ./facter.nix
    ./configuration.nix
  ];
}
