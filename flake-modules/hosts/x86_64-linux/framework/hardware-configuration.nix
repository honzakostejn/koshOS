{
  inputs,
  ...
}: {
  imports = [
    # https://github.com/NixOS/nixos-hardware/blob/master/framework/13-inch/7040-amd/README.md
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  hardware.framework.enableKmod = true;
}