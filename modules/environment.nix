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
      alsa-utils
      brightnessctl
      fastfetch
      gh
      git
      htop
      neovim
      spice-autorandr
      spice-vdagent
    ];
  };
}