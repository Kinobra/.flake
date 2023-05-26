{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.prismlauncher;

in {
  options.myPrograms.prismlauncher = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      prismlauncher
    ];
  };
}
