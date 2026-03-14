{ inputs, ... }: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeModules.honzakostejn = ../home/honzakostejn;
}
