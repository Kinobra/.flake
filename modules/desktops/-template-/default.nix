{ config, lib, ... }:

with lib;
let cfg = config.myPrograms.template;

in {
  options.myPrograms.template = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    # write config for all hosts
    { }

    # write config for this host
    (mkIf cfg.enable {
      # hardware-configuration.nix
      # configuration.nix
    })
  ];
}
