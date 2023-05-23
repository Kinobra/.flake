{ config, lib, ... }:

with lib;
let cfg = config.myPrograms.alacritty;

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
          opacity = 0.86;
        };
        font = {
          normal = {
            family = "fira code";
          };
          size = 11;
        };
        colors = {
          primary = {
            foreground = "#f8f8f8";
            background = "#000000";
          };
          normal = {
            black   = "#241f31";
            red     = "#a51d2d";
            green   = "#26a269";
            yellow  = "#e66100";
            blue    = "#1a5fb4";
            magenta = "#613583";
            cyan    = "#e5a50a";
            white   = "#9a9996";
          };
          bright = {
            black   = "#5e5c64";
            red     = "#ed333b";
            green   = "#57e389";
            yellow  = "#ff7800";
            blue    = "#3584e4";
            magenta = "#c061cb";
            cyan    = "#f6d32d";
            white   = "#ffffff";
          };
        };
      };
    };

    home.sessionVariables = {
      TERM="alacritty";
    };
    home.programs.nushell.extraEnv = mkIf config.myPrograms.nushell.enable ''
      let-env TERM = alacritty
    '';
  };
}
