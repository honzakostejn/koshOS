{ lib
, config
, ...
}: {
  options = {
    home.honzakostejn.programs.nushell = {
      enable = lib.mkEnableOption "Nushell shell" // { default = true; };
    };
  };

  config = lib.mkIf config.home.honzakostejn.programs.nushell.enable {
    programs.nushell = {
      enable = true;
    };
  };
}
