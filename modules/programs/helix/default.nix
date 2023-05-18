{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.helix;

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
            space.f.b = ":sh ${pkgs.kitty}/bin/kitty --class=floating ${pkgs.lf}/bin/lf";
            space.f.f = "file_picker";
            space.f.s = ":w";
            space.f."!" = ":w!";
            space.v = {
              g = ":sh ${pkgs.kitty}/bin/kitty --class=floating ${pkgs.gitui}/bin/gitui";
              f = ":sh ${pkgs.kitty}/bin/kitty --class=floating ${pkgs.git}/bin/git fetch";
              s = ":sh ${pkgs.kitty}/bin/kitty --class=floating ${pkgs.git}/bin/git status";
              l = ":sh ${pkgs.kitty}/bin/kitty --class=floating ${pkgs.git}/bin/git log";
              u = ":sh ${pkgs.kitty}/bin/kitty --class=floating ${pkgs.git}/bin/git push";
              d = ":sh ${pkgs.kitty}/bin/kitty --class=floating ${pkgs.git}/bin/git pull";
              c = ":sh ${pkgs.kitty}/bin/kitty --class=floating ${pkgs.git}/bin/git commit";
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
