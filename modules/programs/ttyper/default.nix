{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.ttyper;

in {
  options.myPrograms.ttyper = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ttyper
    ];
  };
}
