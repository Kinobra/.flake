{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.light;

in {
  options.myPrograms.light = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      light
    ];
  };
}
