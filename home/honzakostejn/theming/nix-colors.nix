{
  self,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    self.homeModules.nixColors
  ];

  options = {
    koshos.home.honzakostejn.theming.nix-colors = {
      enable = lib.mkEnableOption "nix-colors color scheme" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.theming.nix-colors.enable {
    colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;
  };
}