
{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myServices.syncthing;

in {
  options.myServices.syncthing = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.services.syncthing = {
      enable = true;
      # tray.enable = true;
    };
  };
}
