{
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
  ];

  hardware.framework.enableKmod = true;
}