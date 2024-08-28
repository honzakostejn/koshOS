{
  ...
}: let
  workspaceConfiguration = builtins.genList (
    x: let
      # genList is zero-indexed, so we need to add 1 to the index
      workspaceNumber = x + 1;
    in
      "${toString workspaceNumber},monitor:Virtual-1,persistent:true"
  ) 10;

  workspaceBinds = builtins.concatLists (builtins.genList (
    x: let
      key = builtins.toString (x);
      # key 0 is at the end of the keyboard row
      workspaceNumber = if x == 0 then 10 else x;
    in [
      "$mod, ${key}, workspace, ${toString workspaceNumber}"
      "$mod SHIFT, ${key}, movetoworkspace, ${toString workspaceNumber}"
    ]
  ) 10);

in {
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";
    "$menu" = "rofi -show drun";

    "$mod" = "SUPER";
    env = [
      # "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      # "HYPRCURSOR_THEME,${cursorName}"
      # "HYPRCURSOR_SIZE,${toString pointer.size}"
    ];

    monitor = [
      "Virtual-1, 1920x1200@59.88Hz, 0x0, 1"
      ", preferred, auto, 1"
    ];

    exec-once = [
      "swww-daemon"
      "swww img $HOME/dotfiles/wallpapers/forest-fire.gif"
      # "hyprlock"
    ];

    workspace = workspaceConfiguration;

    bind = [
      "$mod, Q, exec, $terminal"
      "$mod, R, exec, $menu"
      "$mod, M, exit,"
    ] ++ workspaceBinds;
  };
}