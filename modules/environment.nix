{
  pkgs,
  ...
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
      git
      htop
      neovim
      spice-autorandr
      spice-vdagent
    ];
  };
}