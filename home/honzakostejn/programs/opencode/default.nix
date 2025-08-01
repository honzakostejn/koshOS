{ lib
, inputs
, pkgs
, config
, ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.system; };
in
{
  options = {
    koshos.home.honzakostejn.programs.opencode = {
      enable = lib.mkEnableOption "opencode - AI coding agent, built for the terminal." // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.opencode.enable {
    programs.opencode = {
      enable = true;
      package = pkgs-unstable.opencode;
    };
  };
}
