{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myHardware.dominus;

in {
  options.myHardware.dominus = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkMerge [
    # write config for all hosts
    { }
    # write config for this host
    (mkIf cfg.enable {

      ## hardware-configuration.nix
      # Do not modify this file!  It was generated by ‘nixos-generate-config’
      # and may be overwritten by future invocations.  Please make changes
      # to /etc/nixos/configuration.nix instead.
      hardware.enableRedistributableFirmware = lib.mkDefault true;

      boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "firewire_ohci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."luks-81ea58ca-2c91-455b-a1db-ab9c38c3ce2e".device = "/dev/disk/by-uuid/81ea58ca-2c91-455b-a1db-ab9c38c3ce2e";
  
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/04aaae47-03b0-4b25-ade0-0b738226a2dd";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/af73ce7b-1510-4f45-bc65-5a4eddb1631d"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s25.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.opengl.driSupport32Bit = true;

      boot.kernelPackages = pkgs.linuxPackages_zen;

      ## configuration.nix
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  programs.nix-ld.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
      environment.systemPackages = with pkgs; [
        libwacom
      ];
    })
  ];
}
