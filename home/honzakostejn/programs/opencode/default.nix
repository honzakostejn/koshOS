{ lib
, config
, ...
}: {
  options = {
    koshos.home.honzakostejn.programs.opencode = {
      enable = lib.mkEnableOption "opencode - AI coding agent, built for the terminal." // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.opencode.enable {
    programs.opencode = {
      enable = true;
    };
  };
}
