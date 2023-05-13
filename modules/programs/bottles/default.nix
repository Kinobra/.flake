{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.bottles;

in {
  options.myPrograms.bottles = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bottles
    ];
  };
}
