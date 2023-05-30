{ config, lib, ... }:

with lib;
let cfg = config.myHardware.orion;

in {
  options.myHardware.orion = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    # write config for all hosts
    {
      programs.ssh.extraConfig = ''
        Host orion
        	HostName 5.75.233.44
        	IdentityFile ~/.ssh/sourcehut
        	User root
      '';
    }

    # write config for this host
    (mkIf cfg.enable {

      ## hardware-configuration.nix

      # boot.kernelPackages = pkgs.linuxPackages_zen;

      ## configuration.nix

      # system.stateVersion = "22.11";
    })
  ];
}
