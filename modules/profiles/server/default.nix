{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myProfiles.server;

in {
  options.myProfiles.server = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      helix
      lf
    ];

    system.autoUpgrade = {
      enable = true;
      flake = "sourcehut:~sntx/flake";
      allowReboot = true;
      rebootWindow = {
        lower = "01:00";
        upper = "02:00";
      };
    };

    myPrograms = {
      nushell.enable = true;
    };

    myServices = {
      fail2ban.enable = true;
      nix.enable = true;
      openssh.enable = true;
    };
  };
}
