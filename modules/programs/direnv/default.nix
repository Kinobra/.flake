{ config, lib, ... }:

with lib;
let cfg = config.myPrograms.direnv;

in {
  options.myPrograms.direnv = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # https://github.com/nix-community/nix-direnv
    home.programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        global = {
          warn_timeout = "2m";
        };
      };
    };
  };
}
