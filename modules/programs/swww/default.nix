{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.swww;

in {
  options.myPrograms.swww = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      swww
    ];
  };
}
