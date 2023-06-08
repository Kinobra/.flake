{ pkgs, ... }:
{
  security.protectKernelImage = true;

  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ 39987 ];
  };

  environment.systemPackages = with pkgs; [
    pam_u2f
  ];

  # Enable with:
  # `mkdir -p ~/.config/Yubico`
  # `pamu2fcfg > ~/.config/Yubico/u2f_keys`
  #  add another key: `pamu2fcfg -n >> ~/.config/Yubico/u2f_keys`
  security.pam.services = {
    login.u2fAuth = false;
    sudo.u2fAuth = false;
  };

  security.polkit = {
  enable = true;
  extraConfig = ''
    polkit.addRule(function(action, subject) {
      // c.f. https://github.com/ValveSoftware/steam-for-linux/issues/7856#issuecomment-1339468383
      if (action.id === "org.freedesktop.NetworkManager.settings.modify.system") {
        var name = polkit.spawn(["cat", "/proc/" + subject.pid + "/comm"]);
        if (name.includes("steam")) {
          polkit.log("ignoring steam NM prompt");
          return polkit.Result.NO;
        }
      }
      // c.f. https://nixos.wiki/wiki/Polkit
      if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("network")) {
        return polkit.Result.YES;
      }
    });
  '';
  };
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

  # boot =
  #   {
  #     tmpOnTmpfs = lib.mkDefault true;
  #     cleanTmpDir = lib.mkDefault (!config.boot.tmpOnTmpfs);

  #     kernel.sysctl =
  #       {
  #         # Disable SysRq combo
  #         "kernel.sysrq" = 0;

  #         ## TCP Hardening
  #         # Prevent bogus ICMP errors from filling up logs.
  #         "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
  #         # Reverse path filtering causes the kernel to do source validation of
  #         # packets received from all interfaces. This can mitigate IP spoofing.
  #         "net.ipv4.conf.default.rp_filter" = 1;
  #         "net.ipv4.conf.all.rp_filter" = 1;
  #         # Do not accept IP source route packets (we're not a router)
  #         "net.ipv4.conf.all.accept_source_route" = 0;
  #         "net.ipv6.conf.all.accept_source_route" = 0;
  #         # Don't send ICMP redirects (again, we're not a router)
  #         "net.ipv4.conf.all.send_redirects" = 0;
  #         "net.ipv4.conf.default.send_redirects" = 0;
  #         # Refuse ICMP redirects (MITM mitigations)
  #         "net.ipv4.conf.all.accept_redirects" = 0;
  #         "net.ipv4.conf.default.accept_redirects" = 0;
  #         "net.ipv4.conf.all.secure_redirects" = 0;
  #         "net.ipv4.conf.default.secure_redirects" = 0;
  #         "net.ipv6.conf.all.accept_redirects" = 0;
  #         "net.ipv6.conf.default.accept_redirects" = 0;
  #         # Protects against SYN flood attacks
  #         "net.ipv4.tcp_syncookies" = 1;
  #         # Incomplete protection again TIME-WAIT assassination
  #         "net.ipv4.tcp_rfc1337" = 1;

  #         ## TCP optimization
  #         # TCP Fast Open is a TCP extension that reduces network latency by packing
  #         # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
  #         # both incoming and outgoing connections:
  #         "net.ipv4.tcp_fastopen" = 3;
  #         # Bufferbloat mitigations + slight improvement in throughput & latency
  #         "net.ipv4.tcp_congestion_control" = "bbr";
  #         "net.core.default_qdisc" = "cake";
  #       };
  #     kernelModules = [ "tcp_bbr" ];
  #   };
}
