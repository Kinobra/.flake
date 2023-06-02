{ config, lib, ... }:

with lib;
let cfg = config.myServices.nginx;

in {
  options.myServices.nginx = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
    };

    services.nginx = {
      enable = true;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "${config.user.name}@${config.networking.domain}";
    };
  };
}
