{ config, lib, ... }:

with lib;
let cfg = config.myPrograms.wshowkeys;

in {
  options.myPrograms.wshowkeys = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.wshowkeys.enable = true;
  };
}
