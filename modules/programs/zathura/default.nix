{ config, lib, ... }:

with lib;
let cfg = config.myPrograms.zathura;

in {
  options.myPrograms.zathura = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs.zathura = {
      enable = true;
    };
  };
}
