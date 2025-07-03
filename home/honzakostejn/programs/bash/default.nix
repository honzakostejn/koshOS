{ lib
, config
, ...
}: {
  options = {
    koshos.home.honzakostejn.programs.bash = {
      enable = lib.mkEnableOption "Bash shell" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.bash.enable {
    programs.bash = {
      enable = true;
    };
  };
}
