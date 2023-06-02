{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.brave;

in {
  options.myPrograms.brave = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brave
    ];
  };
}
