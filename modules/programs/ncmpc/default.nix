{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.ncmpc;

in {
  options.myPrograms.ncmpc = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    myServices.mpd.enable = true;

    home.packages = with pkgs; [
      ncmpc
    ];

    home.sessionVariables = {
      MPD_HOST = "${config.home.services.mpd.network.listenAddress}";
      MPD_PORT = "${toString config.home.services.mpd.network.port}";
    };
    home.programs.nushell.extraEnv = mkIf config.myPrograms.nushell.enable ''
      let-env MPD_HOST = ${config.home.services.mpd.network.listenAddress};
      let-env MPD_PORT = ${toString config.home.services.mpd.network.port};
    '';
  };
}
