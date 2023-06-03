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
    security.polkit.enable = true;
    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
      };
    };
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

    users.users."${config.user.name}".extraGroups = [ "libvirtd" ];
    virtualisation.libvirtd.enable = true;
    # home.dconf.enable = true;
    programs.dconf.enable = true;
  };
}
