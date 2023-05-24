{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myHardware.minerva;

in {
  options.myHardware.minerva = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

    ## hardware-configuration.nix

    hardware.enableRedistributableFirmware = true;

    boot.kernelPackages = pkgs.linuxPackages_zen;

    boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    boot.initrd.luks.devices = {
      "luks-cc7369ff-1cb5-43a1-9167-e98ae0b11886" = {
        device = "/dev/disk/by-uuid/cc7369ff-1cb5-43a1-9167-e98ae0b11886";
      };
      "luks-8080a3a6-6063-4c78-a7e5-532b496a0a86" = {
        device = "/dev/disk/by-uuid/8080a3a6-6063-4c78-a7e5-532b496a0a86";
        keyFile = "/crypto_keyfile.bin";
      };
    };
    boot.initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/dfe59648-89c5-467b-b1a4-a2ccc6fdc2ba";
        fsType = "ext4";
      };

    fileSystems."/boot/efi" =
      { device = "/dev/disk/by-uuid/AB73-3953";
        fsType = "vfat";
      };

    swapDevices =
      [ { device = "/dev/disk/by-uuid/7b6f237f-b986-406c-9423-26fbd191f353"; }
      ];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand"; #powersave #ondemand #performance
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    ## configuration.nix

    system.stateVersion = "22.11";

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";

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

    # IPTS
    # microsoft-surface.ipts.enable = true;
    # microsoft-surface.surface-control.enable = true;

    environment.systemPackages = with pkgs; [
      light
    ];

  };
}
