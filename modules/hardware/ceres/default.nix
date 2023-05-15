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
    # Common configuration for virtual machines running under QEMU (using
    # virtio).
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

    ## hardware-configuration.nix
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/e2a01644-091e-4df6-a2cf-78b4be9a32c2";
        fsType = "ext4";
      };

    swapDevices = [ ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.ens3.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    ## configuration.nix

    # Use the GRUB 2 boot loader.
    boot.loader.grub.enable = true;
    # boot.loader.grub.efiSupport = true;
    # boot.loader.grub.efiInstallAsRemovable = true;
    # boot.loader.efi.efiSysMountPoint = "/boot/efi";
    # Define on which hard drive you want to install Grub.
    boot.loader.grub.device = "/dev/sda";

    # networking.hostName = "nixos"; # Define your hostname.
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    # Set your time zone.
    # time.timeZone = "Europe/Amsterdam";

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties.
    # i18n.defaultLocale = "en_US.UTF-8";
    # console = {
    #   font = "Lat2-Terminus16";
    #   keyMap = "us";
    #   useXkbConfig = true; # use xkbOptions in tty.
    # };

    # Enable the X11 windowing system.
    # services.xserver.enable = true;


    

    # Configure keymap in X11
    # services.xserver.layout = "us";
    # services.xserver.xkbOptions = {
    #   "eurosign:e";
    #   "caps:escape" # map caps to escape.
    # };

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Enable sound.
    # sound.enable = true;
    # hardware.pulseaudio.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    # users.users.alice = {
    #   isNormalUser = true;
    #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    #   packages = with pkgs; [
    #     firefox
    #     thunderbird
    #   ];
    # };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    # environment.systemPackages = with pkgs; [
    #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #   wget
    # ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # Copy the NixOS configuration file and link it from the resulting system
    # (/run/current-system/configuration.nix). This is useful in case you
    # accidentally delete configuration.nix.
    # system.copySystemConfiguration = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.11"; # Did you read the comment?
  };
}
