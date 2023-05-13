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
    myPrograms = {
      git.enable = true;
      neovim.enable = true;
    };
    myServices = {
      # fail2ban.enable = true;
      openssh.enable = true;
    };
  };
}
