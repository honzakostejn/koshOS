{ inputs
, pkgs
, lib
, config
, ...
}:
let
  # this one should be passed
  workspaceCount = 10;

  workspaceBinds = builtins.concatLists (builtins.genList
    (
      x:
      let
        key = builtins.toString (x);
        # key 0 is at the end of the keyboard row
        workspaceNumber = if x == 0 then 10 else x;
      in
      [
        "$mod, ${key}, split-workspace, ${toString workspaceNumber}"
        "$mod SHIFT, ${key}, split-movetoworkspace, ${toString workspaceNumber}"
      ]
    )
    workspaceCount);
in
{
  options = {
    koshos.home.honzakostejn.wayland.hyprland.plugins.split-monitor-workspaces = {
      enable = lib.mkEnableOption "Split monitor workspaces plugin" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.wayland.hyprland.plugins.split-monitor-workspaces.enable {
    wayland.windowManager.hyprland.plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
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

      bind = workspaceBinds ++ [
        # window movement
        "$mod SHIFT, $left, split-changemonitor, prev"
        "$mod SHIFT, $right, split-changemonitor, next"

        "$mod, G, split-grabroguewindows"
      ];
    };
  };
}
