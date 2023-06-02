{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.signal;

in {
  options.myPrograms.signal = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      signal-desktop
    ];
  };
}
