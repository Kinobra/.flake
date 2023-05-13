{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.gpg;

in {
  options.myPrograms.gpg = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.dbus.packages = [ pkgs.gcr ];
    programs.gnupg = {
      agent = {
        enable = true;
        pinentryFlavor = "gnome3";
      };
    };
  };
}
