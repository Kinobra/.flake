{ config, lib, inputs, pkgs, ... }:

with lib;
let cfg = config.myPrograms.nx;

in {
  options.myPrograms.nx = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with inputs; [
      nx-fetch.packages."${pkgs.system}".default
      nx-gen.packages."${pkgs.system}".default
      nx-pkgs.packages."${pkgs.system}".default
    ];
  };
}
