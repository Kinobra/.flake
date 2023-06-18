{ config, lib, ... }:

with lib;
let cfg = config.myProfiles.content-production;

in {
  options.myProfiles.content-production = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    myPrograms = {
      kdenlive.enable = true;
      obs-studio.enable = true;
      wshowkeys.enable = true;
    };
  };
}
