{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.helix;

in {
  options.myPrograms.helix = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.programs.helix = {
      enable = true;
      settings = {
        theme = "base16_transparent";
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
        };
        keys.normal = {
          space.q = ":q";
        };
      };
    };
  };
}
