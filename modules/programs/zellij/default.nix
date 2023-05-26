{ config, lib, ... }:

with lib;
let cfg = config.myPrograms.zellij;

in {
  options.myPrograms.zellij = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs.zellij = {
      enable = true;
      settings = let
        colors = config.theme.colors;
      in {
        theme = "${config.theme.name}";
        themes."${config.theme.name}" = {
          fg      = "${colors.primary.foreground}";
          bg      = "${colors.primary.background}";
          black   = "${colors.normal.black}";
          red     = "${colors.normal.red}";
          green   = "${colors.normal.green}";
          yellow  = "${colors.normal.yellow}";
          blue    = "${colors.normal.blue}";
          magenta = "${colors.normal.magenta}";
          cyan    = "${colors.normal.cyan}";
          white   = "${colors.normal.white}";
          orange  = "#D08770";
        };
      };
    };
  };
}
