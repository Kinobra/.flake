{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.imv;

in {
  options.myPrograms.imv = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      imv			# image viewer
    ];
  };
}
