{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myServices.hedgedoc;

in {
  options.myServices.hedgedoc = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.hedgedoc = {
      enable = true;
    };
  };
}
