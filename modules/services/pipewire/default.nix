{ config, lib, ... }:

with lib;
let cfg = config.myServices.pipewire;

in {
  options.myServices.pipewire = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # Enable Sound with pipewire.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    home.configFile."pipewire/pipewire.conf.d/clock-rate.conf".text = ''
      context.properties = { default.clock.rate = 96000 }
    '';
  };
}
