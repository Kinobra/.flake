{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myThemes.abyss;

in {
  options.myThemes.abyss = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    theme = mkDefault {
      name = "abyss";
      type = "dark";
      opacity = 0.34;
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

    home.packages = with pkgs; [ adw-gtk3 ];

    # fonts
    fonts = let
      font = {
        name = "Fira Code";
        package = pkgs.fira-code;
      };
    in {
      enableDefaultFonts = true;
      fonts = with pkgs; [ 
        font.package
        ipafont           # Japanese Fonts
        kochi-substitute  # Japanese Fonts
      ];

      fontconfig = {
        defaultFonts = {
          serif = [ "${font.name}" "IPAGothic" "monospace" ];
          sansSerif = [ "${font.name}" "IPAGothic" "monospace" ];
          monospace = [ "${font.name}" "IPAPMincho" "monospace" ];
        };
      };
    };

    # gtk theming
    programs.dconf.enable = true; # Fixes: error: GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The name ca.desrt.dconf was not provided by any .service files
    home.dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-${config.theme.type}";
        };
      };
    };
    home.configFile = {
      "gtk-2.0/gtkfilechooser.ini".source = ./gtk/2.0/gtkfilechooser.ini;
      "gtk-3.0/gtk.css".source = ./gtk/3.0/gtk.css;
      "gtk-4.0/gtk.css".source = ./gtk/4.0/gtk.css;
    };

    home.pointerCursor = let
      package = pkgs.callPackage ./cursor/google-cursor-white.nix {};
    in {
      name = "${package.package-name}";
      package = package;
      size = 16;
      x11 = {
        enable = true;
        defaultCursor = "${package.package-name}";
      };
      gtk.enable = true;
    };
  };
}
