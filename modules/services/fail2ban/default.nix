{ config, lib, ... }:

with lib;
let cfg = config.myServices.fail2ban;

in {
  options.myServices.fail2ban = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.fail2ban.enable = true;
  };
}
