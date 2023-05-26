{ config, lib, ... }:

with lib;
let cfg = config.myPrograms.mangohud;

in {
  options.myPrograms.mangohud = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs = {
      mangohud = {
        enable = true;
        enableSessionWide = true;
        # settingsPerApplication.mpv = {
        #   no_display = true;
        # };
      };
    };
  };
}
