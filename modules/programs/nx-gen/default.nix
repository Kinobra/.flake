{ config, lib, inputs, pkgs, ... }:

with lib;
let cfg = config.myPrograms.nx-gen;

in {
  options.myPrograms.nx-gen = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ inputs.nx-gen.packages."${pkgs.system}".default ];
  };
}
