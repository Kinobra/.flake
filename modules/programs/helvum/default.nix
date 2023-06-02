{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.helvum;

in {
  options.myPrograms.helvum = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      helvum
    ];
  };
}
