{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myDesktops.kde;
programs.dconf.enable = true;
in
{
  options.myDesktops.kde = {
    enable = mkOption {
      type = types.bool;
      default = false;
  };
};
config = mkIf cfg.enable {
	myPrograms = {
};
  	services.xserver.enable = true;
  	services.xserver.displayManager.sddm.enable = true;
  	services.xserver.desktopManager.plasma5.enable = true;

    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
  	elisa
  	gwenview
  	okular
  	oxygen
  	khelpcenter
  	konsole
  	plasma-browser-integration
  	print-manager
	];        
      };
    }
