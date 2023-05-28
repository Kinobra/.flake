{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.lf;

in {
  options.myPrograms.lf = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ctpv ];
    home.programs.lf = {
      enable = true;
      extraConfig = ''
        set previewer ctpv
        set cleaner ctpvclear
        &ctpv -s $id
        &ctpvquit $id
      '';
    };
  };
}
