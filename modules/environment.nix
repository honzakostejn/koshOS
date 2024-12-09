{ inputs
, pkgs
, ...
}: {
  environment = {
    # variables = {
    #   EDITOR = "nvim";
    # };

    sessionVariables = {
      # hint Electron apps to use wayland
      NIXOS_OZONE_WL = "1";
    };

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/repos/koshos#framework";
      dev-lopata = "cd ~/repos/lopata && nix-shell";
    };

    systemPackages = with pkgs; [
      inputs.swww.packages.${pkgs.system}.swww

      fastfetch
      gh
      git
      htop
      jq
      nixpkgs-fmt
    ];
  };
}
