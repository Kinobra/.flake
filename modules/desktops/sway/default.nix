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
      waybar.enable = true;
      swww.enable = true;
      swaylock.enable = true;
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

    home.configFile."sway/wallpaper.png".source = ./wallpaper.png;

    hardware.opengl.enable = true; # required by sway, home-manager can't enable this
    home.sway = {
      enable = true;
      package = "${pkgs.swayfx}";
      wrapperFeatures.gtk = true;
      config = let
        gaps = 6;
        borders = 0;
        mode_power = "| power [ e | l | h | s | r ]"; # [e]xit | [l]ock | [h]ibernate | [s]hutdown | [r]estart
        mode_resize = "| resize";
      in {
        modifier = "Mod4";

        terminal = "${config.home.sessionVariables.TERM_LAUNCHER or config.home.sessionVariables.TERM}";

        menu = let
          terminal = config.home.sway.config.terminal;
          launcher = "${pkgs.sway-launcher-desktop}/bin/sway-launcher-desktop";
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
            { criteria.app_id = "^launcher$";  command = "floating enable, sticky enable, move position center, resize set 30 ppt 60 ppt"; }
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
          background-init = pkgs.writeScript "background-init"
            ''
              ${pkgs.swww}/bin/swww init
              ${pkgs.swww}/bin/swww img /home/${config.user.name}/.config/sway/bg.png
            '';
        in [
          { command = "exec ${pkgs.autotiling-rs}/bin/autotiling-rs"; }
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
          "${modifier}+i" = "exec ${terminal} -e ${config.home.sessionVariables.EDITOR}";
          "${modifier}+c" = "exec ${terminal} --working-directory ~/.flake -e ${config.home.sessionVariables.EDITOR}";
          "${modifier}+g" = "exec ${terminal} -e ${pkgs.bottom}/bin/btm";
          "${modifier}+u" = "exec ${config.home.sessionVariables.BROWSER}";
          "${modifier}+Shift+e" = "mode '${mode_power}'";
          "${modifier}+r" = "mode '${mode_resize}'";
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
          "${mode_power}" = {
            "l" = "exec ${config.home.sessionVariables.LOCKSCREEN}";
            "e" = "exit";
            "s" = "exec systemctl poweroff";
            "r" = "exec systemctl reboot";
            "h" = "exec systemctl hibernate";
            "Return" = "mode default";
            "Escape" = "mode default";
          };
          "${mode_resize}" = let
            resize_step = "10px";
          in {
            "h" = "resize shrink width ${resize_step}";
            "j" = "resize grow height ${resize_step}";
            "k" = "resize shrink height ${resize_step}";
            "l" = "resize grow width ${resize_step}";
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
        blur_radius 2

        # dimming
        default_dim_inactive 0.14

        # scratchpad
        scratchpad_minimize enable
      '';
    };
  };
}
