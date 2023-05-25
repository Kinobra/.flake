{ config, lib, ... }:

with lib;
let cfg = config.myPrograms.zellij;

in {
  options.myPrograms.zellij = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs.zellij = {
      enable = true;
    };
  };
}
