{ lib, ... }:
{
  imports = [
    ./abyss
  ];

  config.theme = lib.mkOptionDefault {
    name = "default";
    type = "dark";
    opacity = 1;
    # c.f. base16 - default.dark by Chris Kempson
    colors = {
      primary = {
        foreground = "#d0d0d0";
        background = "#151515";
      };
      normal = {
        black   = "#151515";
        red     = "#ac4142";
        green   = "#90a959";
        yellow  = "#f4bf75";
        blue    = "#6a9fb5";
        magenta = "#aa759f";
        cyan    = "#75b5aa";
        white   = "#d0d0d0";
      };
      bright = {
        black   = "#505050";
        red     = "#ac4142";
        green   = "#90a959";
        yellow  = "#f4bf75";
        blue    = "#6a9fb5";
        magenta = "#aa759f";
        cyan    = "#75b5aa";
        white   = "#f5f5f5";
      };
    };
  };
}
