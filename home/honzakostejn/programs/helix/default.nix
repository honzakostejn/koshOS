{ pkgs
, ...
}:

{
  programs.helix = {
    enable = true;

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
}
