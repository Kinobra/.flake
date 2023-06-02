{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.mpv;

in {
  options.myPrograms.mpv = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mpv
    ];
  };
}
