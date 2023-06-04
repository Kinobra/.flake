{ config, lib, inputs, pkgs, ... }:

with lib;
let cfg = config.myPrograms.nx-fetch;

in {
  options.myPrograms.nx-fetch = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ inputs.nx-fetch.packages."${pkgs.system}".default ];
  };
}
