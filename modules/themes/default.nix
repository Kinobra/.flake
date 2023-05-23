{ lib, ... }:
{
  imports = [
    ./abyss
  ];

  config.theme = lib.mkOptionDefault {
    name = "default";
    type = "dark";
    opacity = 1;
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
}
