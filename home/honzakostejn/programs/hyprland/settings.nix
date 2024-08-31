{
  ...
}: let
  wallpaper = let
    url = "https://github.com/honzakostejn/koshOS/blob/main/assets/wallpapers/forest-fire.gif?raw=true";
    sha256 = "005jq0pafwz6pscrsb78h3j8n09qga6bqlxv3yiv4xjp5gmhip2r";
    ext = "gif";
  in
    builtins.fetchurl {
      name = "wallpaper-${sha256}.${ext}";
      inherit url sha256;
    };

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
  home.file = {
    # wallpaper
    ".local/share/swww/wallpaper.gif".source =
      "${wallpaper}";
  };

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
      # lock the screen, because the greetd is auto-logging the user
      "hyprlock"
      "swww-daemon"
      "swww img .local/share/swww/wallpaper.gif"
    ];

    workspace = workspaceConfiguration;

    bind = [
      "$mod, Q, exec, $terminal"
      "$mod, R, exec, $menu"
      "$mod, M, exit,"
    ] ++ workspaceBinds;
  };
}