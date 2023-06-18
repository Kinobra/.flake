{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.kdenlive;

in {
  options.myPrograms.kdenlive = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libsForQt5.kdenlive
    ];
  };
}
