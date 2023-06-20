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
    website = pkgs.writeTextDir "index.html"
    ''
      <!DOCTYPE html>
      <html>
        <head>
          <title>valkyrja.eu</title>
          <style>
            body { text-align: center; }
          </style>
        </head>
        <body>
          <h1>valkyrja.eu</h1>
          <p>This is a very basic static website generated with nix!</p>
        </body>
      </html>
    '';
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
        root = "${website}";
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "${config.user.name}@${domain}";
    };
  };
}
