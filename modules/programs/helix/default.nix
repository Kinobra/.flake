{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myPrograms.helix;

  term = "${config.home.sessionVariables.TERM} --class=floating";

  file_browser = pkgs.writeScript "file-browser"
    "${term} -e ${pkgs.lf}/bin/lf";

  gitui = pkgs.writeScript "gitui"
    "${term} -e ${pkgs.gitui}/bin/gitui";

  git = "${pkgs.git}/bin/git";

  git-fetch = pkgs.writeScript "git-fetch"
    "${term} -e ${git} fetch";

  git-status = let
    git-status-wait = pkgs.writeScript "git-status-wait"
      ''
        ${git} status
        echo "Press Enter to exit..."
        read
      '';
  in pkgs.writeScript "git-status"
    "${term} -e ${git-status-wait}";

  git-log = pkgs.writeScript "git-log"
    "${term} -e ${git} log";

  git-push = pkgs.writeScript "git-push"
    "${term} -e ${git} push";

  git-pull = pkgs.writeScript "git-pull"
    "${term} -e ${git} pull";

  git-commit = pkgs.writeScript "git-commit"
    "${term} -e ${git} commit";
in {
  options.myPrograms.helix = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs.helix = {
      enable = true;
      settings = {
        theme = "${config.theme.name}";
        editor = {
          # behaviour
          scrolloff = 8;
          line-number = "relative";
          cursorline = true;
          auto-save = true;
          mouse = false;

          # instant autocompletion
          idle-timeout = 0;
          completion-trigger-len = 0;

          statusline = {
            left = [ "mode" "spinner" "file-name" ];
            right = [ "version-control" "diagnostics" "selections" "position" ];
          };

          lsp = {
            display-inlay-hints = true;
          };

          cursor-shape = {
            insert = "bar";
            select = "underline";
          };

          file-picker = {
            hidden = false;
          };

          whitespace = {
            render = "all";
            characters = {
              space = "·";
              nbsp = "¬";
              tab = ">";
              newline = "¬";
              tabpad = "=";
            };
          };

          indent-guides = {
            render = true;
          };

          soft-wrap = {
           enable = true;
          };
        };

        keys = {
          normal = {
            space = {
              q = ":q";
              t = ":sh ${term}";
              v = {
                g = ":sh ${gitui}";
                f = ":sh ${git-fetch}";
                s = ":sh ${git-status}";
                l = ":sh ${git-log}";
                u = ":sh ${git-push}";
                d = ":sh ${git-pull}";
                c = ":sh ${git-commit}";
              };
              w = ":w";
              W = ":w!";
              "." = ":sh ${file_browser}";
            };
            X = "extend_line_above";
          };
          insert = {
            j.k = "normal_mode";
          };
        };
      };
      themes = {
        "${config.theme.name}" = {
          inherits = "base16_transparent";
        };
      };
    };

    home.sessionVariables = {
      EDITOR = "hx";
    };
    home.programs.nushell.extraEnv = mkIf config.myPrograms.nushell.enable ''
      let-env EDITOR = hx
    '';
  };
}
