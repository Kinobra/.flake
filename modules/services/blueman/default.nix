{ config, lib, ... }:

with lib;
let cfg = config.myServices.blueman;

in {
  options.myServices.blueman = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.blueman = {
      enable = true;
    };
  };
}
