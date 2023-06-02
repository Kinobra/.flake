{ config, lib, ... }:

with lib;
let cfg = config.myPrograms.template;

in {
  options.myPrograms.template = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # Your configuration here

    ### Home
    # home.packages = with pkgs; [
    #   lorem
    # ];

    # home.sessionVariables = {
    #   LOREM="lorem";
    # };

    # xdg.configFile."lorem/config".source = ./lorem.conf;
    # home.file.".lorem".text = "";

    ### System
    # environment.systemPackages = with pkgs; [
    #   lorem
    # ];

    # environment.variables = rec {
    #   LOREM="lorem";
    # };

    # environment.etc = {
    #   "lorem/config.toml".source = ./config.toml;
    # };
  };
}
