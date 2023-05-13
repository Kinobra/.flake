{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.discord;

in {
  options.myPrograms.discord = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
    ];
  };
}
