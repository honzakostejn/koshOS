{ inputs, ... }: {
  flake.homeModules = {
    nixColors           = inputs.nix-colors.homeManagerModules.default;
    nixvim              = inputs.nixvim.homeModules.nixvim;
    hyprland            = inputs.hyprland.homeManagerModules.default;
    hyprdynamicmonitors = inputs.hyprdynamicmonitors.homeManagerModules.default;
  };
}
