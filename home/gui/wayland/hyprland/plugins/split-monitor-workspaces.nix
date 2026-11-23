{ inputs
, lib

, ...
}:
let
  workspaceCount = 10;

  mod   = "SUPER";
  left  = "J";
  right = "SEMICOLON";

  mkLuaInline = lib.generators.mkLuaInline;
  bind = keys: dsp: { _args = [ keys dsp ]; };
  
  smwModule = "split-monitor-workspaces.lua.split-monitor-workspaces";
  smw = expr: mkLuaInline ''require("${smwModule}").${expr}'';

  smwSource = inputs.split-monitor-workspaces;

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
      monitorId = x / workspaceCount + 1;  # monitor IDs are 1-based, not 0-based
    in { _args = [{
      workspace = toString id;
      default_name = "${toString label}_m${toString monitorId}";
    }]; }
  ) (maxMonitors * workspaceCount);
in
{
  wayland.windowManager.hyprland = {
    extraLuaFiles = {
      "split-monitor-workspaces.lua.globals" = {
        content = "${smwSource}/lua/globals.lua";
        autoLoad = false;
      };
      "split-monitor-workspaces.lua.helpers" = {
        content = "${smwSource}/lua/helpers.lua";
        autoLoad = false;
      };
      "split-monitor-workspaces.lua.monitors" = {
        content = "${smwSource}/lua/monitors.lua";
        autoLoad = false;
      };
      "split-monitor-workspaces.lua.dispatchers" = {
        content = "${smwSource}/lua/dispatchers.lua";
        autoLoad = false;
      };
      "${smwModule}" = {
        content = "${smwSource}/lua/split-monitor-workspaces.lua";
        autoLoad = false;
      };

      # autoLoad defaults to true: this one actually calls setup() on reload/init.
      "split-monitor-workspaces-setup".content = ''
        require("${smwModule}").setup({
          workspace_count = ${toString workspaceCount},
          keep_focused = false,
          enable_notifications = false,
          enable_persistent_workspaces = true,
        })
      '';
    };

    settings = {
      workspace_rule = workspaceNameRules;

      bind = workspaceBinds ++ [
        # change_monitor("prev"/"next") no longer exists in the Lua rewrite;
        # this is Hyprland's own native relative-monitor-focus dispatcher.
        (bind "${mod} + SHIFT + ${left}"  (mkLuaInline ''hl.dsp.window.move({ monitor = "-1" })''))
        (bind "${mod} + SHIFT + ${right}" (mkLuaInline ''hl.dsp.window.move({ monitor = "+1" })''))

        (bind "${mod} + G"                (smw "grab_rogue_windows()"))
      ];
    };
  };
}
