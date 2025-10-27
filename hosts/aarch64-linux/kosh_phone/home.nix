{ config, ... }:
{
  # imports = [
  #   ../../../home/honzakostejn
  # ];

  # koshos.home.honzakostejn.programs.bash.enable = false;
  # koshos.home.honzakostejn.programs.firefox.enable = false;
  # koshos.home.honzakostejn.programs.ghostty.enable = false;
  # koshos.home.honzakostejn.programs.hyprlock.enable = false;
  # koshos.home.honzakostejn.programs.nixvim.enable = false;
  # koshos.home.honzakostejn.programs.quickshell.enable = false;
  # koshos.programs.qutebrowser.enable = false;
  # koshos.home.honzakostejn.programs.satty.enable = false;
  # koshos.home.honzakostejn.programs.teams-for-linux.enable = false;
  # koshos.home.honzakostejn.programs.vscode.enable = false;
  # koshos.home.honzakostejn.programs.winboat.enable = false;
  # koshos.home.honzakostejn.programs.hypridle.enable = false;
  # koshos.home.honzakostejn.programs.shikane.enable = false;
  # koshos.home.honzakostejn.programs.hyprland.enable = false;

  # koshos.home.honzakostejn.programs.helix.enable = true;
  # koshos.home.honzakostejn.programs.nushell.enable = true;
  # koshos.home.honzakostejn.programs.opencode.enable = true;
  # koshos.home.honzakostejn.programs.starship.enable = true;
  # koshos.home.honzakostejn.programs.yazi.enable = true;

  # home.sessionVariables = {
  #   XDG_CONFIG_HOME = config.home.homeDirectory;
  # };

  home.stateVersion = "25.05";

  programs.yazi = {
    enable = true;

    enableNushellIntegration = true;
    shellWrapperName = "y";

    keymap = {
      # https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/keymap-default.toml
      mgr.prepend_keymap = [
        # hopping - remap vim motions to home row keys
        {
          on = [ "j" ];
          run = "leave";
          description = "Go back to the parent directory";
        }
        {
          on = [ "k" ];
          run = "arrow next";
          description = "Move cursor down";
        }
        {
          on = [ "l" ];
          run = "arrow prev";
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

    settings = {
      mgr = {
        show_hidden = true;
        sort_by = "mtime";
        sort_dir_first = true;
        sort_reverse = true;
      };
    };
  };
}
