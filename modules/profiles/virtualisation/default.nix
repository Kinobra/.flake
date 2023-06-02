{ config, lib, ... }:

with lib;
let cfg = config.myProfiles.virtualisation;

in {
  options.myProfiles.virtualisation = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    myPrograms = {
      bottles.enable = true;
    };
    myServices = {
      virtualisation.enable = true;
    };
  };
}
