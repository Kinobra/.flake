{ config, lib, inputs, pkgs, ... }:

with lib;
let cfg = config.myPrograms.nx-launcher;

in {
  options.myPrograms.nx-launcher = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.nx-launcher.packages."${pkgs.system}".default
    ];
    home.sessionVariables = {
      LAUNCHER = "nxlauncher";
    };
    home.programs.nushell.extraEnv = mkIf config.myPrograms.nushell.enable ''
      let-env LAUNCHER = nxlauncher
    '';
  };
}
