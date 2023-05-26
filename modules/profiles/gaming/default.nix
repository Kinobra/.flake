{ config, lib, ... }:

with lib;
let cfg = config.myProfiles.gaming;

in {
  options.myProfiles.gaming = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    myPrograms = {
      # lutris.enable = true;
      # mangohud.enable = true;
      # prismlauncher.enable = true;
      steam.enable = true;
      ttyper.enable = true;
    };
  };
}
