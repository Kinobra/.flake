{ config, lib, ... }:

with lib;
let cfg = config.myServices.murmur;

in {
  options.myServices.murmur = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.murmur = {
      enable = true;
      registerName = "MurMur Server";
      welcometext = "Welcome to this server!";
      # port = 64738; # default 64738
      # openFirewall = true; # uses port
      clientCertRequired = true;
    };

    services.nginx.virtualHosts = mkIf config.myServices.nginx.enable {
      "murmur.${config.networking.domain}" = let
        murmur = config.myServices.murmur;
      in mkIf murmur.enable {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "localhost:${toString config.services.murmur.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
