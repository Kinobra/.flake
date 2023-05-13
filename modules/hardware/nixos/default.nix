{ options, config, lib, pkgs, modulesPath, ... }:

with lib;
let cfg = config.myHardware.nixos;

in {
  options.myHardware.nixos = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

    ## hardware-configuration.nix

    hardware.enableRedistributableFirmware = true;

    boot.kernelPackages = pkgs.linuxPackages_zen;

    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ "dm-snapshot" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    boot.initrd.luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/9eafa0b3-485a-40e6-8889-bb51135c54c4";
        preLVM = true;
        allowDiscards = true;
      };
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/9d53762d-d3af-47c6-9b09-7de43e7b9405";
      fsType = "btrfs";
    };
    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
      interval = "monthly";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/B333-DFF7";
      fsType = "vfat";
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/e6db7ee6-c38e-4d2f-b83d-41e13b2c04ef"; }
    ];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    ## configuration.nix

    system.stateVersion = "22.11";

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Berlin";

    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };

    services.xserver = {
      layout = "us";
      xkbVariant = "";
    };

    nixpkgs.config.allowUnfree = true;
  };
}
