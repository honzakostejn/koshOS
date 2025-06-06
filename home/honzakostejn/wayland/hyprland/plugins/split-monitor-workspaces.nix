{ inputs
, pkgs
, ...
}:
let
  # this one should be passed
  workspaceCount = 10;

in
{
  wayland.windowManager.hyprland.plugins = [
    inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
  ];

  wayland.windowManager.hyprland.settings = {
    plugin = {
      split-monitor-workspaces = {
        count = workspaceCount;
        keep_focused = 0;
        enable_notifications = 0;
        enable_persistent_workspaces = 1;
      };
    };
  };
}
