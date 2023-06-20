{ config, lib, ... }:

with lib;
let cfg = config.myHardware.ceres;

in {
  options.myHardware.ceres = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    # write config for all hosts
    {
      programs.ssh.extraConfig = ''
        Host ceres
        	HostName 5.75.233.44
        	IdentityFile ~/.ssh/sourcehut
        	User ${config.user.name}
      '';
    }

    # write config for this host
    (mkIf cfg.enable {

      ## hardware-configuration.nix

      boot.initrd.availableKernelModules = [
        "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" # module
        "ata_piix" "virtio_pci" "virtio_scsi" "xhci_pci" "sd_mod" "sr_mod" # hardware-configuration
      ];
      boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
      boot.initrd.postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable)
        ''
          # Set the system time from the hardware clock to work around a
          # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
          # to the *boot time* of the host).
          hwclock -s
        '';

      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];

      fileSystems."/" =
        { device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
        };

      swapDevices = [ ];

      networking.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      ## configuration.nix

      boot.loader.grub.enable = true;
      boot.loader.grub.device = "/dev/sda";

      system.stateVersion = "22.11";
    })
  ];
}
