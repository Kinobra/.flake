{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.lorem;

in {
  options.myPrograms.lorem = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lorem
    ];
  };
}
