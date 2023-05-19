{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.librewolf;

in {
  options.myPrograms.librewolf = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs.librewolf = {
      enable = true;
      settings = {
        # behaviour
        "browser.warnOnQuit" = false;
        "browser.warnOnQuitShortcut" = false;
        "browser.sessionstore.resume_from_crash" = false;

        # appearance
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.newtabpage.activity-stream.showSearch" = false;
        "browser.in-content.dark-mode" = true;

        # privacy
        "privacy.resistFingerprinting.randomization.enabled" = true;
        # "privacy.resistFingerprinting.letterboxing" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # userChrome.css
      };
    };

    home.file."./.librewolf/w7hasu4o.default/chrome/userChrome.css".source = ./userChrome.css;

    # required to get keepassxc working, as it currently stores the socket info to `.mozilla` instead of `.librewolf`
    home.file."./.librewolf/native-messaging-hosts/org.keepassxc.keepassxc_browser.json".text = ''
      {
        "allowed_extensions": [
          "keepassxc-browser@keepassxc.org"
        ],
        "description": "KeePassXC integration with native messaging support",
        "name": "org.keepassxc.keepassxc_browser",
        "path": "${pkgs.keepassxc}/bin/keepassxc-proxy",
        "type": "stdio"
      }
      '';

    home.sessionVariables = {
      BROWSER="librewolf";
    };
    home.programs.nushell.extraEnv = mkIf config.myPrograms.nushell.enable ''
      let-env BROWSER = librewolf
    '';
  };
}
