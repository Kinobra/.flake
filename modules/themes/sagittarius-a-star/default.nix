{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myThemes.sagittarius-a-star;

in {
  options.myThemes.sagittarius-a-star = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = let
    font = {
      name = "Fira Code";
      package = pkgs.fira-code;
    };
    colors = {
      theme = "dark"; # light
    };
    cursor = {
      package = pkgs.callPackage ./cursor/google-cursor-white.nix {};
      size = 16;
    };
  in mkIf cfg.enable {
    home.packages = with pkgs; [ adw-gtk3 ];

    # fonts
    fonts = {
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
          color-scheme = "prefer-${colors.theme}";
        };
      };
    };
    home.configFile = {
      "gtk-2.0/gtkfilechooser.ini".source = ./gtk/2.0/gtkfilechooser.ini;
      "gtk-3.0/gtk.css".source = ./gtk/3.0/gtk.css;
      "gtk-4.0/gtk.css".source = ./gtk/4.0/gtk.css;
    };

    home.pointerCursor = {
      name = "${cursor.package.package-name}";
      package = cursor.package;
      size = cursor.size;
      x11 = {
        enable = true;
        defaultCursor = "${cursor.package.package-name}";
      };
      gtk.enable = true;
    };
  };
}
