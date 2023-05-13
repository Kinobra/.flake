{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myServices.borgbackup;

in {
  options.myServices.borgbackup = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.borgbackup = {
      enable = true;
      jobs = {
        homeBackup = {
          paths = [ "/home" ];
          exclude = [ "'**/.archive'" "'**/.cache'" "'**/Steam'" "'**/.steam'" ];
          repo = "/path/to/local/repo";
          encryption = {
            mode = "repokey-blake2";
            passCommand = "cat /home/${config.user.name}/.borgbackupkey";
          };
          compression = "auto,lzma";
          startAt = "daily";
        };
      };
    };
  };
}
