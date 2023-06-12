{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myHardware.apollo;

in {
  options.myHardware.apollo = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    # write config for all hosts
    {
      programs.ssh.extraConfig = ''
        Host apollo
        	HostName 23.88.122.164
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

      system.fsPackages = [ pkgs.sshfs ];
      fileSystems."/mnt/box" =
        { device = "u333008@u333008.your-storagebox.de:/";
          fsType = "sshfs";
          options = [
            # Filesystem options
            "allow_other"          # for non-root access
            "_netdev"              # this is a network fs
            "x-systemd.automount"  # mount on demand

            # SSH options
            "reconnect"              # handle connection drops
            "ServerAliveInterval=15" # keep connections alive
            "IdentityFile=/var/secrets/box"
          ];
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
