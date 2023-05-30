{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myHardware.template;

in {
  options.myHardware.template = {
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

      ## hardware-configuration.nix

      boot.kernelPackages = pkgs.linuxPackages_zen;

      ## configuration.nix

      system.stateVersion = "22.11";
    })
  ];
}
