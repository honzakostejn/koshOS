{ pkgs
, ...
}: {
  programs.npm = {
    enable = true;
  };

  programs.mcp = {
    enable = true;
    servers = {
      playwright = {
        command = "npx";
        args = [
          "@playwright/mcp@latest"
          "--executable-path" "/etc/profiles/per-user/honzakostejn/bin/chromium"
          # this is a default value "--user-data-dir" "/home/honzakostejn/.cache/ms-playwright/mcp-chrome"
        ];
      };
    };
  };
}
