{ inputs
, ...
}: {
  imports = [
    inputs.nixos-facter-modules.nixosModules.facter
  ];

  config.facter.reportPath =
    if builtins.pathExists ./facter.json then
      ./facter.json
    else
      throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";
}
