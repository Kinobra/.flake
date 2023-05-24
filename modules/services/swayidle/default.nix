{ config, lib, ... }:

with lib;
let cfg = config.myServices.swayidle;

in {
  options.myServices.swayidle = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.services.swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "${config.home.sessionVariables.LOCKSCREEN}"; }
      ];
      timeouts = [
        { timeout = 1800; command = "${config.home.sessionVariables.LOCKSCREEN}"; }
      ];
    };
  };
}
