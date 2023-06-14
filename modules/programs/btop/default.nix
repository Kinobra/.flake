{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.btop;

in {
  options.myPrograms.btop = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      btop
    ];
    home.sessionVariables = {
      RESOURCE_MONITOR = "btop";
    };
    home.programs.nushell.extraEnv = mkIf config.myPrograms.nushell.enable ''
      let-env RESOURCE_MONITOR = btop
    '';
  };
}
