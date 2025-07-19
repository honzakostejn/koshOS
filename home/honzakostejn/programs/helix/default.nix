{ inputs
, pkgs
, lib
, config
, ...
}: {
  options = {
    koshos.home.honzakostejn.programs.helix = {
      enable = lib.mkEnableOption "Helix editor" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.helix.enable {
    programs.helix = {
      enable = true;
      package = inputs.helix.packages.${pkgs.system}.helix;

      defaultEditor = true;

      extraPackages = with pkgs; [
        nixpkgs-fmt
        marksman
      ];

      settings = {
        theme = "catppuccin_mocha";

        editor = {
          line-number = "relative";
        };

        keys = {
          normal = {
            # replace vim keys with home row keys
            j = "move_char_left";
            k = "move_visual_line_down";
            l = "move_visual_line_up";
            ";" = "move_char_right";

            h = "collapse_selection";

            # yazi integration
            C-y = [
              ":sh rm -f /tmp/helix-yazi"
              ":insert-output yazi %{buffer_name} --chooser-file=/tmp/helix-yazi"
              ":insert-output echo \\x1b[?1049h\\x1b[?2004h > /dev/tty"
              ":open %sh{cat /tmp/helix-yazi}"
              ":redraw"
            ];
          };
        };
      };

      languages = {
        language = [
          {
            name = "nix";
            formatter = {
              command = "nixpkgs-fmt";
            };
            auto-format = true;
          }
        ];
      };
    };
  };
}
