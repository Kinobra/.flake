{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myServices.mpd;

in {
  options.myServices.mpd = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mpc-cli
    ];

    home.services.mpd = {
      enable = true;
      musicDirectory = /home/${config.user.name}/Music;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "MPD Pipewire output"
        }
      '';
      network = {
        startWhenNeeded = true;
        listenAddress = "127.0.0.1";
        port = 6600;
      };
    };

    # home.services.mpd-discord-rpc = {
    #   enable = false;
    #   settings = {
    #     hosts = [ "localhost:6600" ];
    #     format = {
    #       details = "$title";
    #       state = "On $album by $artist";
    #     };
    #   };
    # };
  };
}
