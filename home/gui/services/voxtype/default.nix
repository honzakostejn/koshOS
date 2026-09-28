{ config, lib, pkgs, ... }:
let
  # the daemon runs the output hooks with `sh -c`, and the module's default
  # PATH holds neither a shell nor hyprctl, so both are needed here for
  # `voxtype setup compositor hyprland`-style hooks to work at all
  runtimePath = lib.makeBinPath [
    pkgs.bashInteractive
    pkgs.coreutils
    pkgs.which
    pkgs.wl-clipboard
    pkgs.wtype
    config.wayland.windowManager.hyprland.package
  ];
in
{
  services.voxtype = {
    enable = true;

    # vulkan backend for the 780M, ~35x realtime on whisper
    # https://voxtype.io/#performance-comparison
    package = pkgs.voxtype-vulkan;

    # so the daemon's wtype/wl-copy can reach the compositor
    wayland.display = "wayland-1";

    # models are too big for the nix store, so the model-loader service
    # (~/.local/share/voxtype/models) fetches them before voxtype.service
    loadModels = [ "large-v3-turbo" ];

    environment.PATH = runtimePath;

    # https://voxtype.io/docs
    settings = {
      # the hotkey is bound in hyprland (see wayland/hyprland/settings/binds.nix),
      # so the evdev fallback stays off — it would need `input` group membership
      hotkey.enabled = false;
      # required by `voxtype record` and `voxtype status`
      state_file = "auto";

      # multilingual, so both czech and english dictation work
      # https://voxtype.io/#choose-your-model
      whisper = {
        model = "large-v3-turbo";
        language = "auto";
      };

      output = {
        # nix-owned equivalent of `voxtype setup compositor hyprland`: without
        # these, typed text hits SUPER+<letter> binds while SUPER is still held
        # https://github.com/peteonrails/voxtype/blob/main/docs/TROUBLESHOOTING.md#modifier-key-interference-hyprlandswayriver
        pre_recording_command = "hyprctl dispatch submap voxtype_recording";
        pre_output_command = "hyprctl dispatch submap voxtype_suppress";
        post_output_command = "hyprctl dispatch submap reset";
      };
    };
  };
}
