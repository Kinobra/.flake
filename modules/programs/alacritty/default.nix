{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myPrograms.alacritty;

  terminal-launcher = pkgs.writeScript "alacritty-launcher" ''
    (alacritty msg create-window "$@" || alacritty "$@")
  '';

in {
  options.myPrograms.alacritty = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs.alacritty = {
      enable = true;
      settings = {
        window = {
          decorations = "none";
          opacity = config.theme.opacity;
        };
        font = {
          normal = {
            family = "fira code";
          };
          size = 11;
        };
        colors = config.theme.colors;
      };
    };

    home.sessionVariables = {
      TERM = "alacritty";
      TERM_LAUNCHER = "${terminal-launcher}";
    };
    home.programs.nushell.extraEnv = mkIf config.myPrograms.nushell.enable ''
      let-env TERM = alacritty
      let-env TERM_LAUNCHER = ${terminal-launcher}
    '';
  };
}
