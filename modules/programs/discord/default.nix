{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.discord;

in {
  options.myPrograms.discord = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
    ];

    home.programs.discocss = {
      enable = true;
      discordAlias = false;
      css = let
        colors = config.theme.colors;
        opacity = "10"; # toHex(0.381966 (abyss opacity) * 255) / 6 (discord stacks backgrounds)
      in ''
        .theme-dark {
          --background-primary: ${colors.primary.background}${opacity};
          --background-primary-alt: ${colors.primary.background}${opacity};
          --background-secondary: ${colors.primary.background}${opacity};
          --background-secondary-alt: ${colors.primary.background}${opacity};
          --background-tertiary: ${colors.primary.background}${opacity};
        }
      '';
    };
  };
}
