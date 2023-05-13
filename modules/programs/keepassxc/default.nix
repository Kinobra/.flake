{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.keepassxc;

in {
  options.myPrograms.keepassxc = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      keepassxc
    ];
  };
}
