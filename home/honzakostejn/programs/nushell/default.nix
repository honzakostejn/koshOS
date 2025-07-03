{ lib
, config
, ...
}: {
  options = {
    koshos.home.honzakostejn.programs.nushell = {
      enable = lib.mkEnableOption "Nushell shell" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.nushell.enable {
    programs.nushell = {
      enable = true;
      shellAliases = {
        "koshos rebuild" = "sudo nixos-rebuild switch --flake ~/repos/koshos#framework";
      };
    };
  };
}
