{
  config,
  pkgs,
  lib,
  ...
}:
let
  toLua = lib.generators.toLua { };
  mkLuaInline = lib.generators.mkLuaInline;

  send-shortcut-to-electron = pkgs.writeShellApplication {
    name = "send-shortcut-to-electron";
    runtimeInputs = [
      pkgs.jq
    ];
    text = builtins.readFile ../scripts/send-shortcut-to-electron.sh;
  };
  take-screenshot = pkgs.writeShellApplication {
    name = "take-screenshot";
    runtimeInputs = [
      pkgs.hyprshot
      pkgs.jq
      pkgs.wl-clipboard
    ];
    text = builtins.readFile ../scripts/take-screenshot.sh;
  };

  mod   = "SUPER";
  left  = "J";
  down  = "K";
  up    = "L";
  right = "SEMICOLON";

  # noctalia's own session action, which raises its lockscreen directly instead
  # of relying on it picking up logind's Lock signal
  lock       = "${config.programs.noctalia.package}/bin/noctalia msg session lock";
  launcher   = "${config.programs.noctalia.package}/bin/noctalia msg panel-toggle launcher";
  bitwarden  = "${config.programs.noctalia.package}/bin/noctalia msg panel-toggle launcher /bw ";
  screenshot = "${take-screenshot}/bin/take-screenshot";
  electron   = "${send-shortcut-to-electron}/bin/send-shortcut-to-electron";
  voxtype    = "${config.services.voxtype.package}/bin/voxtype";

  exec = cmd: mkLuaInline "hl.dsp.exec_cmd(${toLua cmd})";
  bind = keys: dsp: { _args = [ keys dsp ]; };
  # hyprlang's bind<l|e|i|...> suffixes are now a flags table passed
  flagged = flags: map (b: b // { _args = b._args ++ [ flags ]; });
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (bind "${mod} + SPACE"       (exec launcher))
        (bind "${mod} + B"           (exec bitwarden))
        (bind "${mod} + RETURN"      (exec "ghostty"))
        (bind "${mod} + Q"           (mkLuaInline "hl.dsp.window.close()"))
        (bind "${mod} + SHIFT + Q"   (mkLuaInline "hl.dsp.window.kill()"))
        (bind "${mod} + ALT + L"     (exec lock))
        (bind "${mod} + F4"          (mkLuaInline "hl.dsp.exit()"))

        (bind "${mod} + T"           (mkLuaInline "hl.dsp.window.float({ toggle = true })"))
        (bind "${mod} + T"           (mkLuaInline "hl.dsp.window.resize({ x = 768, y = 1024, exact = true })"))

        (bind "${mod} + M"           (mkLuaInline "hl.dsp.window.fullscreen({ mode = 1 })"))
        (bind "${mod} + F"           (mkLuaInline "hl.dsp.window.fullscreen({ mode = 0 })"))

        (bind "${mod} + ${left}"     (mkLuaInline "hl.dsp.focus({ direction = \"l\" })"))
        (bind "${mod} + ${down}"     (mkLuaInline "hl.dsp.focus({ direction = \"d\" })"))
        (bind "${mod} + ${up}"       (mkLuaInline "hl.dsp.focus({ direction = \"u\" })"))
        (bind "${mod} + ${right}"    (mkLuaInline "hl.dsp.focus({ direction = \"r\" })"))

        (bind "${mod} + W"           (exec "qutebrowser --basedir ~/.config/qutebrowser/honzakostejn"))
        (bind "${mod} + SHIFT + W"   (exec "qutebrowser --basedir ~/.config/qutebrowser/NETWORG"))
        (bind "${mod} + C"           (exec "code ~/repos/koshos"))
        (bind "${mod} + Y"           (exec "ghostty -e yazi"))

        # voxtype push-to-talk: hold to record, release to transcribe and type
        # the text at the cursor. `record start` is only the trigger — the
        # daemon switches to the voxtype_recording submap once the mic opens
        # (pre_recording_command, see services/voxtype), and that submap is
        # where the release is handled
        (bind "${mod} + S"           (exec "${voxtype} record start"))

        (bind "${mod} + R"           (mkLuaInline "hl.dsp.submap(\"screenshot\")"))

        (bind "CONTROL + SHIFT + M"  (exec "${electron} 'CONTROL SHIFT, M' class teams-for-linux"))

        (bind "${mod} + SHIFT + C"   (exec "${pkgs.hyprpicker}/bin/hyprpicker -a -f hex"))

        (bind "${mod} + equal"       (exec "hyprctl keyword cursor:zoom_factor 2"))
        (bind "${mod} + minus"       (exec "hyprctl keyword cursor:zoom_factor 1"))
      ]

      # bindm
      ++ flagged { mouse = true; } [
        (bind "${mod} + CONTROL_L"   (mkLuaInline "hl.dsp.window.drag()"))
        (bind "${mod} + ALT_L"       (mkLuaInline "hl.dsp.window.resize()"))
      ]

      # bindl
      ++ flagged { locked = true; } [
        (bind "switch:Lid Switch"    (exec lock))
        (bind "${mod} + ALT_L + D"   (mkLuaInline "hl.dsp.dpms({ action = \"toggle\" })"))
      ]

      # bindlei
      ++ flagged { locked = true; repeating = true; ignore_mods = true; } [
        (bind "XF86MonBrightnessUp"   (exec "${lib.getExe pkgs.brightnessctl} set 5%+"))
        (bind "XF86MonBrightnessDown" (exec "${lib.getExe pkgs.brightnessctl} set 5%-"))
        (bind "XF86AudioRaiseVolume"  (exec "${pkgs.pamixer}/bin/pamixer -i 5"))
        (bind "XF86AudioLowerVolume"  (exec "${pkgs.pamixer}/bin/pamixer -d 5"))
      ]
      
      # bindli
      ++ flagged { locked = true; ignore_mods = true; } [
        (bind "XF86AudioMute"        (exec "${pkgs.pamixer}/bin/pamixer --toggle-mute"))
        (bind "XF86AudioMicMute"     (exec "${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute"))
        (bind "XF86AudioNext"        (exec "${pkgs.playerctl}/bin/playerctl next"))
        (bind "XF86AudioPrev"        (exec "${pkgs.playerctl}/bin/playerctl previous"))
        (bind "XF86AudioPlay"        (exec "${pkgs.playerctl}/bin/playerctl play-pause"))
        (bind "XF86AudioStop"        (exec "${pkgs.playerctl}/bin/playerctl stop"))
      ];
    };

    submaps.screenshot.settings.bind = [
      (bind "${mod} + R"         (exec "${screenshot} region"))
      (bind "${mod} + R"         (mkLuaInline "hl.dsp.submap(\"reset\")"))
      (bind "${mod} + S"         (exec "${screenshot} screen"))
      (bind "${mod} + S"         (mkLuaInline "hl.dsp.submap(\"reset\")"))
      (bind "${mod} + W"         (exec "${screenshot} window"))
      (bind "${mod} + W"         (mkLuaInline "hl.dsp.submap(\"reset\")"))
      (bind "${mod} + SHIFT + R" (exec "${screenshot} region --freeze"))
      (bind "${mod} + SHIFT + R" (mkLuaInline "hl.dsp.submap(\"reset\")"))
      (bind "${mod} + SHIFT + S" (exec "${screenshot} screen --freeze"))
      (bind "${mod} + SHIFT + S" (mkLuaInline "hl.dsp.submap(\"reset\")"))
      (bind "${mod} + SHIFT + W" (exec "${screenshot} window --freeze"))
      (bind "${mod} + SHIFT + W" (mkLuaInline "hl.dsp.submap(\"reset\")"))
      (bind "ESCAPE"             (mkLuaInline "hl.dsp.submap(\"reset\")"))
    ];

    # nix-owned equivalent of `voxtype setup compositor hyprland`: the daemon
    # enters these from the pre_recording/pre_output/post_output hooks
    # https://github.com/peteonrails/voxtype/blob/main/docs/TROUBLESHOOTING.md#modifier-key-interference-hyprlandswayriver
    #
    # hyprland resolves binds against the active submap, so the release of the
    # push-to-talk bind has to live here — the daemon enters this submap while
    # recording, which is where the key is let go
    submaps.voxtype_recording.settings.bind = [
      (bind "F12"               (exec "${voxtype} record cancel"))
      (bind "F12"               (mkLuaInline "hl.dsp.submap(\"reset\")"))
    ] ++ flagged { release = true; } [
      (bind "${mod} + S"         (exec "${voxtype} record stop"))
    ];

    # swallows the modifiers while voxtype types, otherwise a still-held SUPER
    # turns the transcribed text into SUPER+<letter> binds. F12 is the escape
    # hatch if the daemon dies mid-typing. Escape is deliberately unbound: it
    # makes wtype drop the first character
    # https://github.com/hyprwm/Hyprland/issues/3165
    submaps.voxtype_suppress.settings.bind = [
      (bind "SUPER_L"     (exec "true"))
      (bind "SUPER_R"     (exec "true"))
      (bind "Control_L"   (exec "true"))
      (bind "Control_R"   (exec "true"))
      (bind "Alt_L"       (exec "true"))
      (bind "Alt_R"       (exec "true"))
      (bind "Shift_L"     (exec "true"))
      (bind "Shift_R"     (exec "true"))
      (bind "F12"         (mkLuaInline "hl.dsp.submap(\"reset\")"))
    ];
  };
}
