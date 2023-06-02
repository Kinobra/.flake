{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.cryptomator;

in {
  options.myPrograms.cryptomator = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cryptomator
    ];
  };
}
