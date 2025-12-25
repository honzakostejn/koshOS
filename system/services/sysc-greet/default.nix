{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  customPackage = inputs.sysc-greet.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (finalAttrs: previousAttrs: {
    preInstall = ''
      # replace default files with custom ones
      cp ${./ascii_configs/hyprland.conf} ascii_configs/hyprland.conf
      cp ${./hyprland-greeter-config.conf} config/hyprland-greeter-config.conf
    '';
  });
in
{
  imports = [
    inputs.sysc-greet.nixosModules.default
  ];

  options = {
    koshos.services.sysc-greet = {
      enable = lib.mkEnableOption "sysc-greet authentication daemon" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.koshos.services.sysc-greet.enable {
    services.sysc-greet = {
      enable = true;
      compositor = "hyprland";
    };

    environment.systemPackages = [
      customPackage
    ];

    # override config files in /etc to the custom package
    environment.etc = {
      "greetd/kitty.conf".source = lib.mkForce "${customPackage}/etc/greetd/kitty.conf";
      "greetd/niri-greeter-config.kdl".source = lib.mkForce "${customPackage}/etc/greetd/niri-greeter-config.kdl";
      "greetd/hyprland-greeter-config.conf".source = lib.mkForce "${customPackage}/etc/greetd/hyprland-greeter-config.conf";
      "greetd/sway-greeter-config".source = lib.mkForce "${customPackage}/etc/greetd/sway-greeter-config";
      "polkit-1/rules.d/85-greeter.rules".source = lib.mkForce "${customPackage}/etc/polkit-1/rules.d/85-greeter.rules";
    };

    environment.pathsToLink = [
      "/share/sysc-greet"
    ];

    security.pam.services.sysc-greet.enableGnomeKeyring = true;
  };
}
