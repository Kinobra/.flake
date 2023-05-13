{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myThemes.lorem;

in {
  options.myThemes.lorem = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
  };
}
