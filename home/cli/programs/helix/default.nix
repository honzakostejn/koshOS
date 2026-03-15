{ inputs
, pkgs
, ...
}: {
    home.packages = with pkgs; [
      copilot-language-server
    ];

    programs.helix = {
      enable = true;
      package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.helix.override {
        # tree-sitter-bovex repo was deleted; exclude it to avoid fetch failure
        includeGrammarIf = grammar: grammar.name != "bovex";
      };

      defaultEditor = true;

      extraPackages = with pkgs; [
        nixpkgs-fmt
        marksman
        copilot-language-server
      ];

      settings = {
        theme = "catppuccin_mocha";

        editor = {
          line-number = "relative";
          # inline-completion-timeout = 150;
        };

        keys = {
          normal = {
            # replace vim keys with home row keys
            j = "move_char_left";
            k = "move_visual_line_down";
            l = "move_visual_line_up";
            ";" = "move_char_right";
            g = {
              # replace vim keys with home row keys
              j = "goto_line_start";
              k = "move_line_down";
              l = "move_line_up";
              ";" = "goto_line_end";
            };

            # replace the original ';' binding due to vim keys replacement
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

          insert = {
            tab = "inline_completion_accept";
            C-e = "inline_completion_dismiss";
            C-n = "inline_completion_next";
            C-p = "inline_completion_prev";
            C-space = "inline_completion_trigger";
          };

          select = {
            # replace vim keys with home row keys
            j = "extend_char_left";
            k = "extend_visual_line_down";
            l = "extend_visual_line_up";
            ";" = "extend_char_right";

            # replace the original ';' binding
            h = "collapse_selection";
          };
        };
      };

      languages = {
        language-server.copilot = {
          command = "copilot-language-server";
          args = [ "--stdio" ];
          config = {
            editorInfo = {
              name = "Helix";
              version = "25.01";
            };
            editorPluginInfo = {
              name = "helix-copilot";
              version = "0.1.0";
            };
          };
        };

        language = [
          {
            name = "nix";
            formatter = {
              command = "nixpkgs-fmt";
            };
            auto-format = true;
          }
          {
            name = "markdown";
            language-servers = [ "marksman" "copilot" ];
            formatter = {
              command = "prettier";
              args = [ "--stdin-filepath" "%{buffer_name}" ];
            };
            auto-format = true;
          }
        ];
      };
    };
}

