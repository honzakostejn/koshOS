{ pkgs
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
      fastfetch
      gh
      git
      htop
      neovim
      nixpkgs-fmt
    ];
  };
}
