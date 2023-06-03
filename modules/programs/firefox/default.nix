{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.firefox;

in {
  options.myPrograms.firefox = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs.firefox = {
      enable = true;
      profiles.default = {
        isDefault = true;

        # c.f. https://git.sr.ht/~knazarov/dotfiles/tree/master/item/firefox/userChrome.css
        userChrome = ''
          /* hides the native tabs */
          #TabsToolbar { visibility: collapse !important; }

          /* hides the menu/URL bar */
          #main-window:not([customizing]) #navigator-toolbox:not(:focus-within):not(:hover) {
            margin-top: -45px;
          }
        '';

        settings = {
          # firefox trimming
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.uiCustomization.state" = ''
            {"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["addon_darkreader_org-browser-action","skipredirect_sblask-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","customizableui-special-spring1","urlbar-container","customizableui-special-spring2","downloads-button","ublock0_raymondhill_net-browser-action","keepassxc-browser_keepassxc_org-browser-action","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","addon_darkreader_org-browser-action","skipredirect_sblask-browser-action","keepassxc-browser_keepassxc_org-browser-action","ublock0_raymondhill_net-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","unified-extensions-area"],"currentVersion":19,"newElementCount":8}
          '';

          # behaviour
          "browser.warnOnQuit" = false;
          "browser.warnOnQuitShortcut" = false;
          "browser.sessionstore.resume_from_crash" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.aboutConfig.showWarning" = false;
          "browser.link.open_newwindow" = 2; # Open links in new windows
          "layout.spellcheckDefault" = 0; # Spellcheck off
          "browser.download.useDownloadDir" = false; # Ask where to save downloads
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false; # Do not recommend addons
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false; # Do not recommend features
          "browser.aboutwelcome.enabled" = false;
          "browser.bookmarks.addedImportButton" = false;
          "signon.rememberSignons" = false;

          # appearance
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.newtabpage.activity-stream.showSearch" = false;
          "browser.in-content.dark-mode" = true;

          # privacy sane defaults
          "browser.search.suggest.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;

          # privacy hardening
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.resistFingerprinting.randomization.enabled" = true;
          # "privacy.resistFingerprinting.letterboxing" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # userChrome.css

          # disable telemetry
          # c.f. https://www.howtogeek.com/557929/how-to-see-and-disable-the-telemetry-data-firefox-collects-about-you/
          "devtools.onboarding.telemetry.logged" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.sessions.current.clean" = true;
          # c.f. https://support.mozilla.org/en-US/questions/1197144#question-reply

          # security
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
        };

        search = {
          default = "SearXNG";
          force = true;
          engines = {
            "SearXNG" = {
              urls = [{ template = "https://searx.valkyrja.eu/search?q={searchTerms}"; }];
              iconUpdateURL = "https://searx.valkyrja.eu/static/themes/simple/img/favicon.svg";
              updateInterval = 7 * 24 * 60 * 60 * 1000; # every week
              definedAliases = [ "!sx" ];
            };

            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "!nxp" ];
            };

            "NixOS Wiki" = {
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "!nxw" ];
            };

            "Nix Home-Manager Options" = {
              urls = [{ template = "https://mipmip.github.io/home-manager-option-search?{searchTerms}"; }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "!nxh" ];
            };

            "Invidious" = {
              urls = [{ template = "https://invidious.valkyrja.eu/search?q={searchTerms}"; }];
              iconUpdateURL = "https://invidious.valkyrja.eu/favicon-32x32.png";
              updateInterval = 7 * 24 * 60 * 60 * 1000; # every week
              definedAliases = [ "!inv" ];
            };

            "GitHub" = {
              urls = [{ template = "https://github.com/search?q={searchTerms}"; }];
              iconUpdateURL = "https://github.com/fluidicon.png";
              updateInterval = 7 * 24 * 60 * 60 * 1000; # every week
              definedAliases = [ "!gh" ];
            };
          };
        };

        extensions = [ ];

        bookmarks = [ ];
      };
    };

    home.sessionVariables = {
      BROWSER="firefox";
    };    
    home.programs.nushell.extraEnv = mkIf config.myPrograms.nushell.enable ''
      let-env BROWSER = firefox
    '';
  };
}
