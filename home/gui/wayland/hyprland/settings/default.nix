{ inputs
, pkgs
, lib
, ...
}:
let
  interprocess-communication = pkgs.writeShellApplication {
    name = "interprocess-communication";
    runtimeInputs = with pkgs; [
      socat
      pipewire
    ];
    text = builtins.readFile ../scripts/interprocess-communication.sh;
  };
  toLua = lib.generators.toLua { };
  mkLuaInline = lib.generators.mkLuaInline;
in
{
  imports = [
    ./binds.nix
    ./look-and-feel.nix
  ];

  home.file.".config/hypr/notification.mp3".source =
    ../../../../../assets/sounds/notification.mp3;

  wayland.windowManager.hyprland.settings = {
    config = {
      input = {
        kb_layout = "us,cz";
        kb_variant = ",qwerty";
        kb_options = "grp:alt_shift_toggle";

        follow_mouse = 2;
        accel_profile = "adaptive";
        sensitivity = 0.5;

        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.5;
          clickfinger_behavior = true;
          tap_to_click = false;
        };
      };

      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        background_color = "0x00000000";
        animate_manual_resizes = true;
      };
    };

    on = {
      _args = [
        "hyprland.start"
        (mkLuaInline ''
          function()
            hl.exec_cmd(${toLua "${pkgs.lib.getExe interprocess-communication}"})
          end
        '')
      ];
    };
  };
}
