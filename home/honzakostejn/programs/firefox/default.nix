{ pkgs
, config
, inputs
, ...
}: {
  programs.firefox = {
    enable = true;
    policies = {
      # ExtensionSettings = {
      #   "*" = {
      #     installation_mode = "blocked";
      #     blocked_install_message = "Use home-manager to install extensions!";
      #   };
      # };
    };
    profiles = {
      honzakostejn = {
        id = 0;

        search.engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
        };
        search.force = true;

        settings = {
          # performance settings
          "gfx.webrender.all" = true; # force enable GPU acceleration
          "media.ffmpeg.vaapi.enabled" = true;
          "widget.dmabuf.force-enabled" = true; # required in recent firefoxes

          "extensions.autoDisableScopes" = 0;
          "extensions.pocket.enabled" = false;

          "browser.download.panel.shown" = true;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.translations.neverTranslateLanguages" = "en,cs";
          "browser.startup.page" = 3; # Restore previous session

          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "sidebar.main.tools" = "aichat";

          # misc
          "dom.security.https_only_mode" = true;
          "identity.fxaccounts.enabled" = false;
          "signon.rememberSignons" = true;
        };

        userChrome = ''
          /* some css */                        
        '';

        # these extensions will be installed,
        # but they must be enabled manually in the browser
        extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
          bitwarden
          ublock-origin
          vimium

          youtube-shorts-block
          multi-account-containers

          # missing
          # level-up-for-d365-power-apps
        ];
      };

      # NETWORG = {
      #   id = 1;

      #   settings = {
      #     "extensions.autoDisableScopes" = 0;
      #     "dom.security.https_only_mode" = true;
      #     "browser.download.panel.shown" = true;
      #     "identity.fxaccounts.enabled" = false;
      #     "signon.rememberSignons" = false;

      #     "browser.toolbars.bookmarks.visibility" = "never";
      #     "browser.translations.neverTranslateLanguages" = "en,cs";
      #     "browser.startup.page" = 3; # Restore previous session

      #     "privacy.history.custom" = true;
      #     "network.cookie.cookieBehavior" = 0; # block cross-site tracking cookies
      #     "privacy.donottrackheader.enabled" = true;
      #     "privacy.bounceTrackingProtection.hasMigratedUserActivationData" = true;
      #     "privacy.sanitize.clearOnShutdown.hasMigratedToNewPrefs2" = true;
      #     "privacy.clearOnShutdown_v2.cache" = false;
      #     "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      #     "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
      #   };

      #   userChrome = ''
      #     /* some css */                        
      #   '';

      #   # these extensions will be installed,
      #   # but they must be enabled manually in the browser
      #   extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
      #     bitwarden
      #     ublock-origin
      #     vimium
      #   ];
      # };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "default-web-browser" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
    };
  };
}
