{ config, lib, ... }:

with lib;
let cfg = config.myServices.lorem;

in {
  options.myServices.lorem = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.lorem = {
      enable = true;
    };
  };
}
