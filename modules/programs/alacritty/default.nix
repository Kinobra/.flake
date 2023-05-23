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
          # opacity = 0.86;
          # opacity = 0.38;
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
      TERM="alacritty";
    };
    home.programs.nushell.extraEnv = mkIf config.myPrograms.nushell.enable ''
      let-env TERM = alacritty
    '';
  };
}
