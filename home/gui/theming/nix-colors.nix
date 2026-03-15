{
  self,
  inputs,
  ...
}: {
  imports = [
    self.homeModules.nixColors
  ];

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;
}