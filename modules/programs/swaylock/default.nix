{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.swaylock;

in {
  options.myPrograms.swaylock = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    security.pam.services.swaylock = {};
    home.programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        screenshot = true;
        clock = true;
        indicator = true;
        effect-pixelate = "8";
        effect-blur = "8x8";
        effect-greyscale = true;
        # color = "808080";
        # font-size = 24;
        # indicator-idle-visible = false;
        # indicator-radius = 100;
        # line-color = "ffffff";
        # show-failed-attempts = true;
      };
    };

    home.sessionVariables = {
      LOCKSCREEN = "swaylock";
    };
    home.programs.nushell.extraEnv = mkIf config.myPrograms.nushell.enable ''
      let-env LOCKSCREEN = swaylock
    '';
  };
}
