{ inputs
, lib
, pkgs
, ...
}:
let
  workspaceCount = 10;

  mod   = "SUPER";
  left  = "J";
  right = "SEMICOLON";

  mkLuaInline = lib.generators.mkLuaInline;
  bind = keys: dsp: { _args = [ keys dsp ]; };
  smw = expr: mkLuaInline "function() return hl.plugin.split_monitor_workspaces.${expr} end";

  workspaceBinds = builtins.concatLists (builtins.genList (x:
    let
      key = toString x;
      wn  = toString (if x == 0 then 10 else x);
    in [
      (bind "${mod} + ${key}"         (smw "workspace(${wn})"))
      (bind "${mod} + SHIFT + ${key}" (smw "move_to_workspace(${wn})"))
    ]
  ) workspaceCount);

  # workspaces are indexed globally from 0..N
  # the workspace rules are assigning a custom name to each workspace,
  # which is then used by the shell's bar to display the workspace number
  # this helps the user with navigating workspaces across multiple monitors
  # by keyboard binds
  maxMonitors = 5;
  workspaceNameRules = builtins.genList (x:
    let
      id = x + 1;
      label = lib.mod id workspaceCount;
      monitorId = x / workspaceCount;
    in { _args = [{
      workspace = toString id;
      default_name = "${toString label}_m${toString monitorId}";
    }]; }
  ) (maxMonitors * workspaceCount);
in
{
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
    ];

    settings = {
      config.plugin.split_monitor_workspaces = {
        count = workspaceCount;
        keep_focused = false;
        enable_notifications = false;
        enable_persistent_workspaces = true;
      };

      workspace_rule = workspaceNameRules;

      bind = workspaceBinds ++ [
        (bind "${mod} + SHIFT + ${left}"  (smw "change_monitor(\"prev\")"))
        (bind "${mod} + SHIFT + ${right}" (smw "change_monitor(\"next\")"))

        (bind "${mod} + G"                (smw "grab_rogue_windows()"))
      ];
    };
  };
}
