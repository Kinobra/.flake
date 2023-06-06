{ config, lib, ... }:

with lib;
let cfg = config.myServices.nix-serve;

in {
  options.myServices.nix-serve = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };


  config = mkMerge [
    {
      nix = {
        settings = {
          # substituters = [ ];
          trusted-public-keys = [
            "nixos-1.valkyrja.eu:lHFEsyz9HBX0H48QfFFPT+qDjdpsJ+3vRXlzE7TYF2U="
          ];
        };
      };
    }
    (mkIf cfg.enable {
      services.nix-serve = {
        enable = true;
        openFirewall = true;
        port = 5000;
        # nix-store --generate-binary-cache-key ${config.networking.hostName}-1.${config.networking.domain} /var/cache-priv-key.pem /var/cache-pub-key.pem
        # chown nix-serve /var/cache-priv-key.pem
        # chmod 600 /var/cache-priv-key.pem
        secretKeyFile = "/var/cache-priv-key.pem";
      };
    })
  ];
}