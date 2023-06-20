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

  config = let
    domain = "${config.networking.domain}";
  in mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."${domain}" = {
        addSSL = true;
        enableACME = true;
        root = "/var/www/${domain}";
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "${config.user.name}@${domain}";
    };
  };
}
