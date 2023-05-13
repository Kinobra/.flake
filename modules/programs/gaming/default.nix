{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.myPrograms.gaming;

in {
  options.myPrograms.gaming = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    home.programs = {
      mangohud = {
        enable = true;
        enableSessionWide = true;
        # settingsPerApplication.mpv = {
        #   no_display = true;
        # };
      };
    };

    home.packages = with pkgs; [
      # wine
      # winetricks
      lutris
      # prismlauncher

      ttyper
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
