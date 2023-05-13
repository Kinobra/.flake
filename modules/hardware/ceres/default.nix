{ options, config, lib, pkgs, modulesPath, ... }:

with lib;
let cfg = config.myHardware.ceres;

in {
  options.myHardware.ceres = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

    ## hardware-configuration.nix

    boot.loader.grub.device = "/dev/sda";
    boot.initrd.availableKernelModules = [
      "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" # qemu
      "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" # auto generated
    ];
    boot.initrd.kernelModules = [
      "virtio_balloon" "virtio_console" "virtio_rng" # qemu
      "nvme" # auto generated
    ];
    boot.initrd.postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable)
    ''
      # Set the system time from the hardware clock to work around a
      # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
      # to the *boot time* of the host).
      hwclock -s
    '';

    fileSystems."/" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };

    ## networking.nix
    # generated at runtime by nixos-infect

    networking = {
      nameservers = [
        "2a01:4ff:ff00::add:2"
        "2a01:4ff:ff00::add:1"
        "185.12.64.2"
      ];

      defaultGateway = "172.31.1.1";
      defaultGateway6 = {
        address = "fe80::1";
        interface = "eth0";
      };

      dhcpcd.enable = false;
      usePredictableInterfaceNames = lib.mkForce false;
      interfaces = {
        eth0 = {
          ipv4.addresses = [
            { address="91.107.221.240"; prefixLength=32; }
          ];
          ipv6.addresses = [
            { address="2a01:4f8:c012:d756::1"; prefixLength=64; }
            { address="fe80::9400:2ff:fe2f:7426"; prefixLength=64; }
          ];
          ipv4.routes = [
            { address = "172.31.1.1"; prefixLength = 32; }
          ];
          ipv6.routes = [
            { address = "fe80::1"; prefixLength = 128; }
          ];
        };
      };
    };

    services.udev.extraRules = ''
      ATTR{address}=="96:00:02:2f:74:26", NAME="eth0"
    '';

    ## configuration.nix

    system.stateVersion = "22.11";

    boot.tmp.cleanOnBoot = true;
    zramSwap.enable = true;

    ## ssh.nix

    services.openssh = {
      enable = true;
      settings = {
        permitRootLogin = "yes";
      };
    };
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCcOm5bv/HZtyaavJ0xBFvZJ6fLfuUxhtFj1UU7YXfi" # nixos
    ];
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
