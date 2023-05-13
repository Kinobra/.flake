{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.lf;

in {
  options.myPrograms.lf = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs.lf = {
      enable = true;
    };
  };
}
