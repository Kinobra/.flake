{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.obs-studio;

in {
  options.myPrograms.obs-studio = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      obs-studio
    ];
  };
}
