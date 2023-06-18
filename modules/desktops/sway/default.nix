{ config, lib, pkgs, ... }:

with lib;
let cfg = config.myDesktops.sway;

in
{
  options.myDesktops.sway = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    myPrograms = {
      nx-launcher.enable = true;
      swaylock.enable = true;
      swww.enable = true;
      waybar.enable = true;
    };

    myServices = {
      mako.enable = true;
      pipewire.enable = true;
      swayidle.enable = true;
    };

    home.packages = with pkgs; [
      wl-clipboard 		# wl-copy and wl-paste for copy/paste from stdin / stdout
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = let
            swayfx = pkgs.writeScript "swayfx"
              "${pkgs.swayfx}/bin/sway";
          in "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd '${swayfx}'";
          user = "greeter";
        };
      };
    };
    # fix to prevent systemd messaged from appearing on the greetd tui
    systemd.services.greetd = {
      serviceConfig.Type = "idle";
      unitConfig.After = [
        # "nixos-upgrade.service"
        "NetworkManager.service"
        "NetworkManager-wait-online.service"
        "sys-subsystem-bluetooth-devices-hci0.device" # minerva
      ];
    };

    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    };
    environment.sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "sway";
    };

    home.configFile."sway/wallpaper.png".source = ./wallpaper.png;

    hardware.opengl.enable = true; # required by sway, home-manager can't enable this
    home.sway = {
      enable = true;
      package = "${pkgs.swayfx}";
      wrapperFeatures.gtk = true;
      config = let
        gaps = 6;
        borders = 0;
        mode = {
          power = "| power [ e | l | h | s | r ]"; # [e]xit | [l]ock | [h]ibernate | [s]hutdown | [r]estart
          resize = "| resize";
          editor = "| editor [ i | c | o | p | u ]"; # [i] | [c]onfig | .[o]rg | [p]rojects | [u]ni
        };
      in {
        modifier = "Mod4";

        terminal = "${config.home.sessionVariables.TERM_LAUNCHER or config.home.sessionVariables.TERM}";

        menu = let
          terminal = config.home.sway.config.terminal;
          launcher = config.home.sessionVariables.LAUNCHER;
        in "${terminal} --class=launcher -e ${launcher}";

        bars = [{ command = "${config.home.sessionVariables.BAR}"; }];

        fonts = {
          names = [ "Fira Code" ];
          style = "Semibold";
          size = 12.0;
        };

        gaps = { inner = gaps; };

        window = {
          border = borders;
          commands = [
            { criteria.app_id = "^launcher$";  command = "floating enable, sticky enable, move position center, resize set 61 ppt 61 ppt"; }
            { criteria.app_id = "^floating$";  command = "floating enable, move position center, resize set 86 ppt 86 ppt"; }
            { criteria.app_id = "imv|mpv|org\\.keepassxc\\.KeePassXC";  command = "floating enable"; }
            { criteria.app_id = "com.github.wwmm.easyeffects";  command = "move scratchpad"; }
            { criteria.class = "Anki";  command = "floating enable"; }
          ];
        };
        floating = { border = borders; };

        input."*" = {
          accel_profile = "flat";
          dwt = "enable"; # disable while typing
          tap = "enable";
        };

        seat."*" = let
          cursor = {
            name = "${config.home.pointerCursor.name}";
            size = config.home.pointerCursor.size;
          };
        in {
          hide_cursor = "when-typing enable";
          xcursor_theme = "${cursor.name} ${toString cursor.size}";
        };

        startup = let
          # c.f. https://nixos.wiki/wiki/Sway
          dbus-sway-environment = pkgs.writeScript "dbus-sway-environment"
            ''
              dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
              systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
              systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
            '';

          background-init = pkgs.writeScript "background-init"
            ''
              ${pkgs.swww}/bin/swww init
              ${pkgs.swww}/bin/swww img /home/${config.user.name}/.config/sway/bg.png
            '';
        in [
          { command = "exec ${pkgs.autotiling-rs}/bin/autotiling-rs"; }
          { command = "exec ${dbus-sway-environment}"; } # always = true; 
          { command = "exec ${background-init}"; }
        ];

        keybindings = let
          modifier = config.home.sway.config.modifier;
          terminal = config.home.sway.config.terminal;
          menu = config.home.sway.config.menu;

          grim = "${pkgs.grim}/bin/grim";
          slurp = "${pkgs.slurp}/bin/slurp";
          wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
          jq = "${pkgs.jq}/bin/jq";
          light = "${pkgs.light}/bin/light";
          pactl = "${pkgs.pulseaudio}/bin/pactl";
        in lib.mkOptionDefault {
          # Basics
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+Shift+c" = "reload";
          # Applications
          "${modifier}+g" = "exec ${terminal} --class=floating -e ${config.home.sessionVariables.RESOURCE_MONITOR}";
          "${modifier}+s" = "exec ${terminal} --class=floating -e pulsemixer";
          "${modifier}+n" = "exec ${terminal} --class=floating -e nmtui";
          "${modifier}+u" = "exec ${config.home.sessionVariables.BROWSER}";
          "${modifier}+Shift+e" = "mode '${mode.power}'";
          "${modifier}+r" = "mode '${mode.resize}'";
          "${modifier}+i" = "mode '${mode.editor}'";
          "${modifier}+p" = "exec ${grim} -g \"$(${slurp})\" - | ${wl-copy}";
          "${modifier}+Shift+p" = "exec ${grim} -o $(swaymsg -t get_outputs | ${jq} -r '.[] | select(.focused) | .name') - | ${wl-copy}";
          # Misc
          "${modifier}+Shift+m" = "smart_gaps toggle";
          # Modifier Keys
          "XF86MonBrightnessDown" = "exec ${light} -U 10";
          "XF86MonBrightnessUP" = "exec ${light} -A 10";
          "XF86AudioRaiseVolume" = "${pactl} set-sink-volume @DEFAULT_SINK@ +1%";
          "XF86AudioLowerVolume" = "${pactl} set-sink-volume @DEFAULT_SINK@ -1%";
          "XF86AudioMute" = "${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
        };

        modes = lib.mkOptionDefault {
          "${mode.power}" = {
            "l" = "exec ${config.home.sessionVariables.LOCKSCREEN}";
            "e" = "exit";
            "s" = "exec systemctl poweroff";
            "r" = "exec systemctl reboot";
            "h" = "exec systemctl hibernate";
            "Return" = "mode default";
            "Escape" = "mode default";
          };
          "${mode.resize}" = let
            resize_step = "10px";
          in {
            "h" = "resize shrink width ${resize_step}";
            "j" = "resize grow height ${resize_step}";
            "k" = "resize shrink height ${resize_step}";
            "l" = "resize grow width ${resize_step}";
            "Return" = "mode default";
            "Escape" = "mode default";
          };
          "${mode.editor}" = let
            editor = "${config.home.sessionVariables.EDITOR}";
            terminal = config.home.sway.config.terminal;
          in {
            "i" = "exec ${terminal} -e ${editor}";
            "c" = "exec ${terminal} --working-directory ~/.flake -e ${editor}";
            "o" = "exec ${terminal} --working-directory ~/.org -e ${editor}";
            "p" = "exec ${terminal} --working-directory ~/Documents/Projects -e ${editor}";
            "u" = "exec ${terminal} --working-directory ~/Documents/Uni -e ${editor}";
            "Return" = "mode default";
            "Escape" = "mode default";
          };
        };
      };

      extraConfig = ''
        ## swayfx specific options

        # corners
        corner_radius 6
        smart_corner_radius enable

        # shadows
        shadows enable
        shadows_on_csd enable

        # blur
        blur enable
        blur_xray disable
        blur_passes 3
        blur_radius 6

        # dimming
        default_dim_inactive 0.14

        # scratchpad
        scratchpad_minimize enable
      '';
    };
  };
}
