{ lib
, config
, pkgs
, ...
}: {
  options = {
    koshos.home.honzakostejn.programs.zk = {
      enable = lib.mkEnableOption "zk is a plain text note-taking assistant that leverages the power of the command line." // { default = true; };
    };
  };

  config = lib.mkIf config.koshos.home.honzakostejn.programs.zk.enable {
    programs.zk = {
      enable = true;
      settings = {
        notebook = {
          dir = "~/repos/jarvis";
        };
        extra = {
          author = "@honzakostejn";
          visibility = "public";
        };
        note = {
          language = "en";
          default-title = "{{format-date now '%y-%m-%d'}}-{{id}}";
          filename = "{{format-date now '%y-%m-%d'}}-{{slug title}}";
          extension = "md";
          template = "default.md";
        };
        group = {
          daily = {
            paths = [ "journal/daily" ];
            template = "daily.md";
            extra = {
              visibility = "private";
            };
          };
          weekly = {
            paths = [ "journal/weekly" ];
            template = "weekly.md";
            extra = {
              visibility = "private";
            };  
          };
        };
      };
    };
  };
}
