{ config, lib, ... }:

with lib;
let cfg = config.myServices.nebula;

in {
  options.myServices.nebula = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.services.nebula.networks."nebula" = {
      enable = true;
      ca = "/etc/nebula/ca.crt";
      cert = "/etc/nebula/host.crt";
      key = "/etc/nebula/host.key";
      staticHostMap = {
        "10.0.0.1" = [ "<WIP>:4242" ];
      };
      isLighthouse = false;
      lighthouses = [
        "10.0.0.1"
      ];
      firewall.outbound = [
        {
          port = "any";
          proto = "any";
          host = "any";
        }
      ];
      firewall.inbound = [
        {
          port = "any";
          proto = "icmp";
          host = "any";
        }
      ];
    };
  };
}
