{ options, config, lib, pkgs, modulesPath, ... }:

with lib;
let cfg = config.myHardware.template;

in {
  options.myHardware.template = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

    ## hardware-configuration.nix

    hardware.enableRedistributableFirmware = true;

    boot.kernelPackages = pkgs.linuxPackages_zen;

    # boot.initrd.availableKernelModules = [ ];
    # boot.initrd.kernelModules = [ ];
    # boot.kernelModules = [ ];
    # boot.extraModulePackages = [ ];

    # boot.initrd.luks.devices = { };

    # fileSystems."/" = { };

    # fileSystems."/boot" = { };

    # swapDevices = [ ];

    # networking.useDHCP = lib.mkDefault true;

    # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    ## configuration.nix

    # system.stateVersion = "22.11";

    # boot.loader.systemd-boot.enable = true;
    # boot.loader.efi.canTouchEfiVariables = true;

    # networking.networkmanager.enable = true;

    # time.timeZone = "Europe/Berlin";

    # i18n.defaultLocale = "en_GB.UTF-8";
    # i18n.extraLocaleSettings = {
    #   LC_ADDRESS = "de_DE.UTF-8";
    #   LC_IDENTIFICATION = "de_DE.UTF-8";
    #   LC_MEASUREMENT = "de_DE.UTF-8";
    #   LC_MONETARY = "de_DE.UTF-8";
    #   LC_NAME = "de_DE.UTF-8";
    #   LC_NUMERIC = "de_DE.UTF-8";
    #   LC_PAPER = "de_DE.UTF-8";
    #   LC_TELEPHONE = "de_DE.UTF-8";
    #   LC_TIME = "de_DE.UTF-8";
    # };

    # services.xserver = {
    #   layout = "us";
    #   xkbVariant = "";
    # };

    # nixpkgs.config.allowUnfree = true;

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
