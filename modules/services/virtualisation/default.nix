{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myServices.virtualisation;

in {
  options.myServices.virtualisation = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

    users.groups.nixosvmtest = {};
    users.users.vm = {
      isSystemUser = true;
      initialPassword = "test";
      group = "nixosvmtest";
    };

    virtualisation.vmVariant = {
      virtualisation = {
        qemu = {
          package = pkgs.qemu;
          # options = [
          #   "-vga qxl"
          # ];
        };
        memorySize =  4096; # Use 2048MiB memory.
        cores = 2;
      };
    };

    home.packages = with pkgs; [
      virt-manager
    ];

    # users.users."${config.user.name}".extraGroups = [ "libvirtd" ];
    virtualisation.libvirtd.enable = true;
    # home.dconf.enable = true;
    programs.dconf.enable = true;
  };
}
