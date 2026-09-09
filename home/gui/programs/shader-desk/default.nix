{ inputs, pkgs, ... }:
let
  src = inputs.shader-desk;
  date = src.lastModifiedDate;
  day = "${builtins.substring 0 4 date}-${builtins.substring 4 2 date}-${builtins.substring 6 2 date}";
in
{
  imports = [ ./module.nix ];

  services.shader-desk = {
    enable = true;

    package = pkgs.callPackage ./package.nix {
      inherit src;
      version = "0-unstable-${day}";
    };

    # Metaballs that a light source chases the cursor around. The other scenes
    # shipped with the engine are listed by its embedded init.lua; swap this
    # for e.g. "02_oil_painting", "synthwave_demo" or "orbital_harmonics".
    scene = "01_liquid_mesh";
  };
}
