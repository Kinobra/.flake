{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myPrograms.helix;

  term = "${pkgs.kitty}/bin/kitty --class=floating";

  file_browser = pkgs.writeScript "file-browser"
    "${term} ${pkgs.lf}/bin/lf";

  gitui = pkgs.writeScript "gitui"
    "${term} ${pkgs.gitui}/bin/gitui";

  git = "${pkgs.git}/bin/git";

  git-fetch = pkgs.writeScript "git-fetch"
    "${term} ${git} fetch";

  git-status = let
    git-status-wait = pkgs.writeScript "git-status-wait"
      ''
        ${git} status
        echo "Press Enter to exit..."
        read
      '';
  in pkgs.writeScript "git-status"
    "${term} ${git-status-wait}";

  git-log = pkgs.writeScript "git-log"
    "${term} ${git} log";

  git-push = pkgs.writeScript "git-push"
    "${term} ${git} push";

  git-pull = pkgs.writeScript "git-pull"
    "${term} ${git} pull";

  git-commit = pkgs.writeScript "git-commit"
    "${term} ${git} commit";
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
        theme = "base16_transparent";
        editor = {
          # behaviour
          scrolloff = 8;
          line-number = "relative";
          cursorline = false;

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
            space.f.b = ":sh ${file_browser}";
            space.f.f = "file_picker";
            space.f.s = ":w";
            space.f."!" = ":w!";
            space.t = ":sh ${term}";
            space.v = {
              g = ":sh ${gitui}";
              f = ":sh ${git-fetch}";
              s = ":sh ${git-status}";
              l = ":sh ${git-log}";
              u = ":sh ${git-push}";
              d = ":sh ${git-pull}";
              c = ":sh ${git-commit}";
            };
            space.q = ":q";
          };
          insert = {
            j.k = "normal_mode";
          };
        };
      };
    };

    home.sessionVariables = {
      EDITOR="hx";
    };    
    home.programs.nushell.extraEnv = mkIf config.myPrograms.nushell.enable ''
      let-env EDITOR = hx
    '';
  };
}
