{pkgs, config, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    policies = {
      DisablePocket = true;
      FirefoxHome.SponsoredTopSites = false;
      FirefoxSuggest.SponsoredSuggestions = false;
      NoDefaultBookmarks = true;
    };
    profiles = {
      ${config.home.username} = {
        search = {
          default = "DuckDuckGo";
          force = true;
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };
          };
        };
        extensions = with config.nur.repos.rycee.firefox-addons; [
          consent-o-matic
          libredirect
          redirector
          ublock-origin
        ];
        settings = {
          "browser.warnOnQuitShortcut" = false;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.newtabpage.pinned" = "[]";
          "browser.compactmode.show" = true;
          "browser.uidensity" = 1;
          "browser.uiCustomization.state" = {
            "placements" = {
              "widget-overflow-fixed-list" = [];
              "unified-extensions-area" = ["gdpr_cavi_au_dk-browser-action"];
              "nav-bar" = [
                "back-button"
                "forward-button"
                "stop-reload-button"
                "customizableui-special-spring1"
                "urlbar-container"
                "customizableui-special-spring2"
                "downloads-button"
                "unified-extensions-button"
                "ublock0_raymondhill_net-browser-action"
              ];
              "TabsToolbar" = ["tabbrowser-tabs" "new-tab-button" "alltabs-button"];
              "PersonalToolbar" = ["import-button" "personal-bookmarks"];
            };
            "seen" = [
              "save-to-pocket-button"
              "developer-button"
              "gdpr_cavi_au_dk-browser-action"
              "ublock0_raymondhill_net-browser-action"
            ];
            "dirtyAreaCache" = ["nav-bar" "PersonalToolbar" "unified-extensions-area" "TabsToolbar"];
            "currentVersion" = 20;
            "newElementCount" = 2;
          };
        };
      };
    };
  };
}
