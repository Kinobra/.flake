{ config, lib, ... }:

with lib;
let cfg = config.myHardware.diana;

in {
  options.myHardware.diana = {
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

      boot.initrd.availableKernelModules = [
        "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" # module
        "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" # hardware-configuration
      ];
      boot.initrd.kernelModules = [ ];

      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" =
        { device = "/dev/disk/by-uuid/b2c88152-d707-4b17-8e57-588f16952c27";
          fsType = "btrfs";
        };

      fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/b2c88152-d707-4b17-8e57-588f16952c27";
          fsType = "btrfs";
        };

      swapDevices = [ ];

      networking.useDHCP = lib.mkDefault true;

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      ## configuration.nix

      boot.loader.grub.enable = true;
      boot.loader.grub.device = "/dev/sda";

      system.stateVersion = "22.11";
    })
  ];
}
