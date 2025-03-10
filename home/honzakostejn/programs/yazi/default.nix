{ ...
}: {
  programs.yazi = {
    enable = true;

    enableNushellIntegration = true;

    keymap = {
      manager.prepend_keymap = [
        { run = ""; on = [ "" ];}
      ];
    };
  };
}
