{ lib
, config
, ...
}: {
  options = {
    home.honzakostejn.programs.yazi = {
      enable = lib.mkEnableOption "Yazi file manager" // { default = true; };
    };
  };

  config = lib.mkIf config.home.honzakostejn.programs.yazi.enable {
    programs.yazi = {
      enable = true;

      enableNushellIntegration = true;
      shellWrapperName = "y";

      keymap = {
        # https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/keymap-default.toml
        manager.prepend_keymap = [
          # hopping - remap vim motions to home row keys
          {
            on = [ "j" ];
            run = "leave";
            description = "Go back to the parent directory";
          }
          {
            on = [ "k" ];
            run = "arrow 1";
            description = "Move cursor down";
          }
          {
            on = [ "l" ];
            run = "arrow -1";
            description = "Move cursor up";
          }
          {
            on = [ ";" ];
            run = "enter";
            description = "Enter the child directory";
          }

          # navigation - remap vim motions to home row keys
          {
            on = [ "J" ];
            run = "back";
            description = "Go back to the previous directory";
          }
          {
            on = [ ":" ];
            run = "forward";
            description = "Go forward to the next directory";
          }

          # seeking - remap vim motions to home row keys
          {
            on = [ "K" ];
            run = "seek 5";
            description = "Seek down 5 units in the preview";
          }
          {
            on = [ "L" ];
            run = "seek -5";
            description = "Seek up 5 units in the preview";
          }
        ];
      };
    };
  };
}
