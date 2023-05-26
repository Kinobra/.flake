{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.lutris;

in {
  options.myPrograms.lutris = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # wine
      # winetricks
      lutris
    ];

    # Starcitizen
    # boot.kernel.sysctl = {
    #   "vm.max_map_count" = 16777216;
    # };
    # networking.hosts = {
    #   "127.0.0.1" = [ "modules-cdn.eac-prod.on.epicgames.com" ];
    # };

    # Lutris
    # libraries
    # environment.systemPackages = with pkgs; [
    #   (lutris.override {
    #     extraLibraries =  pkgs: [
    #       # List library dependencies here
    #     ];
    #   })
    # ];
    # packages
    # environment.systemPackages = with pkgs; [
    #   (lutris.override {
    #      extraPkgs = pkgs: [
    #        # List package dependencies here
    #      ];
    #   })
    # ];
  };
}
