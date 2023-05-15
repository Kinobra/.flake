{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myProfiles.server-minimal;

in {
  options.myProfiles.server-minimal = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      git
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
      lf.enable = true;
      nushell.enable = true;
      neovim.enable = true;
    };

    myServices = {
      fail2ban.enable = true;
      nix.enable = true;
      openssh.enable = true;
    };
  };
}
