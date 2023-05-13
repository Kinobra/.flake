{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.kitty;

in {
  options.myPrograms.kitty = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs.kitty = {
      enable = true;
      font = {
        name = "fira code";
        package = pkgs.fira-code;
        size = 11;
      };
      settings = {
        # cursor
        cursor_shape = "block";
        # mouse
        mouse_hide_wait = "-1.0";
        # window layout
        placement_strategy = "center";
        hide_window_decorations = "yes";
        confirm_os_window_close = "0";
        # color scheme
        foreground = "#f8f8f8";
        background = "#000000";
        background_opacity = "0.86";
        color0  = "#241f31"; # black
        color8  = "#5e5c64"; # black (bright)
        color1  = "#a51d2d"; # red
        color9  = "#ed333b"; # red (bright)
        color2  = "#26a269"; # green
        color10 = "#57e389"; # green (bright)
        color3  = "#e66100"; # yellow
        color11 = "#ff7800"; # yellow (bright)
        color4  = "#1a5fb4"; # blue
        color12 = "#3584e4"; # blue (bright)
        color5  = "#613583"; # magenta
        color13 = "#c061cb"; # magenta (bright)
        color6  = "#e5a50a"; # cyan
        color14 = "#f6d32d"; # cyan (bright)
        color7  = "#9a9996"; # white
        color15 = "#ffffff"; # white (bright)
      };
    };
  };
}
