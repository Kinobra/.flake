{ config, lib, ... }:

with lib;
let cfg = config.myPrograms.steam;

in {
  options.myPrograms.steam = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs.steam.enable = true;
  };
}
