{ lib
, config
, pkgs
, ...
}:
let
  qutebrowserPkg = pkgs.qutebrowser.overrideAttrs (oldAttrs: {
    name = "qutebrowser.koshos";

    postInstall = oldAttrs.postInstall + ''
      # remove the default desktop entry file, as there're multiple profiles
      rm $out/share/applications/org.qutebrowser.qutebrowser.desktop

      # replace the qute-bitwarden userscript with a custom one
      cp ${./qute-bitwarden.py} $out/share/qutebrowser/userscripts/qute-bitwarden
      patchPythonScript $out/share/qutebrowser/userscripts/qute-bitwarden
    '';
  });
in
{
  options = {
    koshos.programs.qutebrowser = {
      enable = lib.mkEnableOption "Qutebrowser web browser" // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.programs.qutebrowser.enable {
    programs.qutebrowser = {
      enable = true;
      package = qutebrowserPkg.override {
        # DRM support - https://wiki.nixos.org/wiki/Qutebrowser
        enableWideVine = true;
      };

      # edit settings in the baseConfig.py and config.py files due to multiple profiles
    };

    home.file = {
      ".config/qutebrowser/honzakostejn/config/baseConfig.py".source = ./baseConfig.py;
      ".config/qutebrowser/honzakostejn/config/config.py".source = ./honzakostejn/config.py;
      ".config/qutebrowser/honzakostejn/config/theme.py".source = ./theme.py;

      ".config/qutebrowser/NETWORG/config/baseConfig.py".source = ./baseConfig.py;
      ".config/qutebrowser/NETWORG/config/config.py".source = ./NETWORG/config.py;
      ".config/qutebrowser/NETWORG/config/theme.py".source = ./theme.py;
    };

    home.packages = with pkgs; [
      # dependencies of the qute-bitwarden userscript
      bitwarden-cli
      keyutils
    ];

    xdg.desktopEntries = {
      "qutebrowser.honzakostejn" = {
        name = "qutebrowser [honzakostejn]";
        genericName = "Personal browser profile";
        exec = ''qutebrowser --basedir ${config.home.homeDirectory}/.config/qutebrowser/honzakostejn'';
        icon = "qutebrowser";
      };
      "qutebrowser.NETWORG" = {
        name = "qutebrowser [NETWORG]";
        genericName = "Work browser profile";
        exec = ''qutebrowser --basedir ${config.home.homeDirectory}/.config/qutebrowser/NETWORG'';
        icon = "qutebrowser";
      };
    };
  };
}
