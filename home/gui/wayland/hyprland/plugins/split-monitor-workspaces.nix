{ inputs
, lib
, ...
}:
let
  workspaceCount = 10;

  mod   = "SUPER";
  left  = "J";
  right = "SEMICOLON";

  workspaceBindings = lib.concatStringsSep "\n" (builtins.genList (x:
    let
      key = toString x;
      wn  = toString (if x == 0 then 10 else x);
    in ''
      hl.bind("${mod} + ${key}", smw.workspace("${wn}"))
      hl.bind("${mod} + SHIFT + ${key}", smw.move_to_workspace_silent("${wn}"))
    ''
  ) workspaceCount);
in
{
  xdg.configFile."hypr/smw".source = "${inputs.split-monitor-workspaces}/lua";

  wayland.windowManager.hyprland.extraConfig = ''
    do
      local cfg_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
      package.path = package.path .. ";" .. cfg_home .. "/hypr/smw/?.lua"
      local smw = require("split-monitor-workspaces")
      smw.setup({
        workspace_count = ${toString workspaceCount},
        keep_focused = false,
        enable_notifications = false,
        enable_persistent_workspaces = true,
      })
      ${workspaceBindings}
      hl.bind("${mod} + G", smw.grab_rogue_windows())
    end
  '';
}
