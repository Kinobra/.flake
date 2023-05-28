{ config, lib, pkgs, ... }:

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
      settings = let
        colors = config.theme.colors;
      in {
        # cursor
        cursor_shape = "block";
        # mouse
        mouse_hide_wait = "-1.0";
        # window layout
        placement_strategy = "center";
        hide_window_decorations = "yes";
        confirm_os_window_close = "0";
        # color scheme
        foreground = "${colors.primary.foreground}";
        background = "${colors.primary.background}";
        background_opacity = toString config.theme.opacity;
        color0  = "${colors.normal.black}"; # black
        color1  = "${colors.normal.red}"; # red
        color2  = "${colors.normal.green}"; # green
        color3  = "${colors.normal.yellow}"; # yellow
        color4  = "${colors.normal.blue}"; # blue
        color5  = "${colors.normal.magenta}"; # magenta
        color6  = "${colors.normal.cyan}"; # cyan
        color7  = "${colors.normal.white}"; # white
        color8  = "${colors.bright.black}"; # black (bright)
        color9  = "${colors.bright.red}"; # red (bright)
        color10 = "${colors.bright.green}"; # green (bright)
        color11 = "${colors.bright.yellow}"; # yellow (bright)
        color12 = "${colors.bright.blue}"; # blue (bright)
        color13 = "${colors.bright.magenta}"; # magenta (bright)
        color14 = "${colors.bright.cyan}"; # cyan (bright)
        color15 = "${colors.bright.white}"; # white (bright)
      };
    };

    home.sessionVariables = {
      TERM="kitty";
    };
    home.programs.nushell.extraEnv = mkIf config.myPrograms.nushell.enable ''
      let-env TERM = kitty
    '';
  };
}
