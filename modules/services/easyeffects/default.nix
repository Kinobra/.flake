{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myServices.easyeffects;

in {
  options.myServices.easyeffects = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.services.easyeffects = {
      enable = true;
    };
    home.sway.config.startup = mkIf config.home.sway.enable [
      { command = "exec ${pkgs.easyeffects}/bin/easyeffects"; }
    ];
  };
}
