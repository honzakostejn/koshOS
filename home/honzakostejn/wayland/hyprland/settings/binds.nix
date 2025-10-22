{ pkgs
, lib
, ...
}:
let
  custom-hyprlock-script = import ../../../programs/hyprlock/custom-hyprlock-script.nix { inherit pkgs lib; };
  toggle-mute-teams = pkgs.writeShellApplication {
    name = "toggle-mute-teams";
    runtimeInputs = [ pkgs.jq ];
    text = builtins.readFile ../scripts/toggle-mute-teams.sh;
  };

in
{
  wayland.windowManager.hyprland = {
    settings = {
      "$mod" = "SUPER";

      "$left" = "J";
      "$down" = "K";
      "$up" = "L";
      "$right" = "SEMICOLON";

      "$terminal" = "ghostty";
      "$menu" = "rofi -show drun";
      "$lock" = "${custom-hyprlock-script}/bin/custom-hyprlock-script";
      "$toggle-mute-teams" = "${toggle-mute-teams}/bin/toggle-mute-teams";

      # bind[flag]
      # [flags]
      # l -> locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
      # r -> release, will trigger on release of a key.
      # e -> repeat, will repeat when held.
      # n -> non-consuming, key/mouse events will be passed to the active window in addition to triggering the dispatcher.
      # m -> mouse, see below.
      # t -> transparent, cannot be shadowed by other binds.
      # i -> ignore mods, will ignore modifiers.
      # s -> separate, will arbitrarily combine keys between each mod/key, see [Keysym combos](#keysym-combos) above.
      # d -> has description, will allow you to write a description for your bind.
      # p -> bypasses the app's requests to inhibit keybinds.

      bind = [
        # basics
        "$mod, SPACE, exec, $menu"
        "$mod, RETURN, exec, $terminal"
        "$mod, Q, killactive"
        "$mod ALT_L, L, exec, $lock"
        "$mod, F4, exit,"

        # window actions
        "$mod, T, togglefloating"
        "$mod, T, resizeactive, exact 768 1047" # iPad portrait (3:4); 1024+23 extra pixels for qutebrowser UI

        "$mod, M, fullscreen, 1"
        "$mod, F, fullscreen, 0"

        # focus movement
        "$mod, $left, movefocus, l"
        "$mod, $down, movefocus, d"
        "$mod, $up, movefocus, u"
        "$mod, $right, movefocus, r"

        # application shortcuts
        "$mod, W, exec, qutebrowser --basedir ~/.config/qutebrowser/honzakostejn"
        "$mod SHIFT, W, exec, qutebrowser --basedir ~/.config/qutebrowser/NETWORG"
        "$mod, C, exec, code ~/repos/koshos"
        # "$mod, A, exec, ${pkgs.hyprpanel}/bin/hyprpanel"

        # screenshots
        "$mod, R, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
        "$mod SHIFT, R, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f - -o - | ${pkgs.wl-clipboard}/bin/wl-copy"

        # toggle mute in MS Teams
        "CONTROL SHIFT, M, exec, $toggle-mute-teams"

        "$mod SHIFT, C, exec, ${pkgs.hyprpicker}/bin/hyprpicker -a -f hex"
      ];
      bindm = [
        "$mod, CONTROL_L, movewindow"
        "$mod, ALT_L, resizewindow"
      ];
      bindl = [
        ", switch:Lid Switch, exec, $lock"
        "$mod ALT_L, D, exec, hyprctl dispatch dpms off && hyprctl dispatch dpms on"
      ];
      bindlei = [
        ", XF86MonBrightnessUp, exec, ${lib.getExe pkgs.brillo} -A 5 -u 200000"
        ", XF86MonBrightnessDown, exec, ${lib.getExe pkgs.brillo} -U 5 -u 200000"
        ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
        ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
      ];
      bindli = [
        ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute"
        ", XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop"
      ];
    };
  };
}
