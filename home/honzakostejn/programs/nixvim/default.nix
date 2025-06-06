{ lib
, config
, inputs
, ...
}: {
  options = {
    home.honzakostejn.programs.nixvim = {
      enable = lib.mkEnableOption "NixVim editor" // { default = false; };
    };
  };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  config = lib.mkIf config.home.honzakostejn.programs.nixvim.enable {
    programs.nixvim = {
      enable = true;

      defaultEditor = false;

      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          transparent_ackground = true;
        };
      };

      opts = {
        number = true; # show line numbers
        relativenumber = true; # show relative line numbers
        shiftwidth = 2; # number of spaces - TAB width
      };

      plugins = {
        lsp = {
          enable = true;
          servers = {
            csharp_ls = {
              enable = true;
            };
          };
        };

        # neorg = {
        #   enable = true;
        # };
      };
    };
  };
}
