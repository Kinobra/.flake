{ options, config, lib, pkgs, ... }:

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
    myProfiles.server-minimal.enable = true;
  };
}
