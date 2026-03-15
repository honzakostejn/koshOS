{ pkgs
, ...
}: {
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
}
