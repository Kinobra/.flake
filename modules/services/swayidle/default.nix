{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myServices.swayidle;

in {
  options.myServices.swayidle = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.services.swayidle = let
      swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
    in {
      enable = true;
      events = [
        { event = "before-sleep"; command = "${swaylock}"; }
      ];
      timeouts = [
        { timeout = 1800; command = "${swaylock}"; }
      ];
    };
  };
}
