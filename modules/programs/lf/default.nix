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
    home.packages = with pkgs; [
      # file previews in the terminal
      ctpv
      # programs requried by ctpv
      delta  # diff
      ffmpeg # audio
      gnupg  # gpg-encrypted
      jq     # json
      unzip  # zip
      lynx   # html
    ];
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
