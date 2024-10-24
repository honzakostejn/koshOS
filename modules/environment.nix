{ inputs
, pkgs
, ...
}: {
  environment = {
    variables = {
      EDITOR = "nvim";
    };

    sessionVariables = {
      # hint Electron apps to use wayland
      NIXOS_OZONE_WL = "1";
    };

    systemPackages = with pkgs; [
      inputs.swww.packages.${pkgs.system}.swww

      fastfetch
      gh
      git
      htop
      jq
      neovim
      nixpkgs-fmt
    ];
  };
}
