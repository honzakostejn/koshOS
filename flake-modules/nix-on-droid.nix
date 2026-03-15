{ inputs, ... }: {
  flake.nixOnDroidConfigurations = {
    kosh_phone = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import inputs.nix-on-droid.inputs.nixpkgs {
        system = "aarch64-linux";
        overlays = [
          inputs.nix-on-droid.overlays.default
        ];
      };
      modules = [
        ../hosts/aarch64-linux/kosh_phone
      ];
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
