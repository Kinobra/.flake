{ config, lib, ... }:

with lib;
let cfg = config.myProfiles.desktop;

in {
  options.myProfiles.desktop = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    myProfiles = {
      desktop-minimal.enable = true;
      gaming.enable = true;
    };

    myPrograms = {
      bottles.enable = true;
      brave.enable = true;
      helvum.enable = true;
    };

    myServices = {
      # nebula.enable = true;
      virtualisation.enable = true;
    };
  };
}
