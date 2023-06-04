{ config, lib, inputs, pkgs, ... }:

with lib;
let cfg = config.myPrograms.nx-pkgs;

in {
  options.myPrograms.nx-pkgs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ inputs.nx-pkgs.packages."${pkgs.system}".default ];
  };
}
