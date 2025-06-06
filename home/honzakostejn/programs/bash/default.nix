{ lib
, config
, ...
}: {
  options = {
    home.honzakostejn.programs.bash = {
      enable = lib.mkEnableOption "Bash shell" // { default = true; };
    };
  };

  config = lib.mkIf config.home.honzakostejn.programs.bash.enable {
    programs.bash = {
      enable = true;
    };
  };
}
