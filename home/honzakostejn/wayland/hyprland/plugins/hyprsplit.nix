{ inputs
, pkgs
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
        "$mod, ${key}, split:workspace, ${toString workspaceNumber}"
        "$mod SHIFT, ${key}, split:movetoworkspace, ${toString workspaceNumber}"
      ]
    )
    workspaceCount);
in
{
  wayland.windowManager.hyprland.plugins = [
    inputs.hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit
  ];

  wayland.windowManager.hyprland.settings = {
    plugin = {
      hyprsplit = {
        num_workspaces = workspaceCount;
        persistent_workspaces = 1;
      };
    };

    bind = workspaceBinds ++ [
      "$mod, G, split:grabroguewindows"
    ];
  };
}
