{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.delta;

in {
  options.myPrograms.delta = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      delta
    ];
    home.programs.git = mkIf config.myPrograms.git.enable {
      extraConfig = {
        core = {
          pager = "delta";
        };
        interactive = {
          diffFilter = "delta --color-only";
        };
        delta = {
          navigate = true;
          light = false;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      };
    };
  };
}
