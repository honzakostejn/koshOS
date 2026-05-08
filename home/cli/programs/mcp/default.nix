{ pkgs
, ...
}: {
  programs.npm = {
    enable = true;
  };
  programs.bun = {
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
      work-iq = {
        command = "npx";
        args = [
          "-y"
          "@microsoft/workiq@latest"
          "mcp"
        ];
        tools = ["*"];
      };
      # ado-networg = {
      #   command = "npx";
      #   args = [
      #     "-y"
      #     "@azure-devops/mcp"
      #     "thenetworg"
      #   ];
      #   tools = ["*"];
      # };
    };
  };

  # home.file.".copilot/mcp-config.json".text = ''
  #   {
  #     "mcpServers": {
  #       "ado-networg": {
  #         "type": "stdio",
  #         "command": "bunx",
  #         "args": ["-y", "@azure-devops/mcp", "thenetworg"],
  #         "tools": ["*"]
  #       }
  #     }
  #   }
  # '';
}