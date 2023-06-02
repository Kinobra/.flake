{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.monero-gui;

in {
  options.myPrograms.monero-gui = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      monero-gui
    ];
  };
}
