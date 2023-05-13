{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myServices.mako;

in {
  options.myServices.mako = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.services.mako = {
      enable = true;

      anchor = "top-center";

      font = "FiraCode Semibold 12";

      backgroundColor = "#000000DB";
      borderColor = "#4C7899FF";
      borderRadius = 6;

      defaultTimeout = 4000;
      ignoreTimeout = true;
    };
  };
}
