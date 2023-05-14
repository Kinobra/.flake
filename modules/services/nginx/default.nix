{ options, config, lib, pkgs, ... }:

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
    services.nginx = {
      enable = true;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "${config.user.name}@${config.networking.domain}";
    };
  };
}
