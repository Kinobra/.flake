{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.gping;

in {
  options.myPrograms.gping = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gping
    ];
  };
}
