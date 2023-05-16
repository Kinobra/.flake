{ options, config, lib, pkgs, ... }:

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
    myProfiles.desktop-minimal.enable = true;

    myPrograms = {
      bottles.enable = true;
      brave.enable = true;
      discord.enable = true;
      gaming.enable = true;
      helvum.enable = true;
    };

    myServices = {
      # nebula.enable = true;
      virtualisation.enable = true;
    };
  };
}
