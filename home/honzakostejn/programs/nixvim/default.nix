{ inputs
, ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    defaultEditor = true;

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
}
