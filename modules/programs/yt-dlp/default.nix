{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.yt-dlp;

in {
  options.myPrograms.yt-dlp = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs.yt-dlp = {
      enable = true;
    };
  };
}
