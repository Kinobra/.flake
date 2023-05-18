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
      # swaylock.enable = true;
    };

    myServices = {
      mako.enable = true;
      pipewire.enable = true;
      # swayidle.enable = true;
    };

    home.packages = with pkgs; [
      wl-clipboard 		# wl-copy and wl-paste for copy/paste from stdin / stdout
    ];

    environment.systemPackages = with pkgs; [
      swayfx
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'sway'";
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

    home.configFile."sway/bg.png".source = ./bg.png;

    home.sway = {
      enable = true;
      package = "${pkgs.swayfx}";
      wrapperFeatures.gtk = true;
      config = let
        gaps = 6;
        borders = 1;
        mode_power = "| power [ e | l | h | s | r ]"; # exit | lockout | hibernate | shutdown | restart
      in {
        modifier = "Mod4";

        terminal = "${pkgs.kitty}/bin/kitty";

        menu = let
          terminal = config.home.sway.config.terminal;
          launcher = "${pkgs.sway-launcher-desktop}/bin/sway-launcher-desktop";
        in "${terminal} --class=launcher ${launcher}";

        bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];

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
            { criteria.app_id = "^floating$";  command = "floating enable, move position center, resize set 86 ptt 86 ppt"; }
            { criteria.app_id = "org.keepassxc.KeePassXC";  command = "floating enable"; }
            { criteria.app_id = "com.github.wwmm.easyeffects";  command = "move scratchpad"; }
            { criteria.class = "Anki";  command = "floating enable"; }
            { criteria.app_id = "mpv";  command = "floating enable"; }
            { criteria.app_id = "imv";  command = "floating enable"; }
          ];
        };
        floating = { border = borders; };

        input."*" = { accel_profile = "flat"; };

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
          "${modifier}+i" = "exec ${terminal} --class=editor $EDITOR";
          "${modifier}+c" = "exec ${terminal} --class=config --working-directory ~/.flake $EDITOR";
          "${modifier}+g" = "exec ${terminal} --class=bottom ${pkgs.bottom}/bin/btm";
          "${modifier}+u" = "exec ${pkgs.firefox}/bin/firefox";
          "${modifier}+Shift+e" = "mode '${mode_power}'";
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
            "l" = "exec ${pkgs.swaylock-effects}/bin/swaylock";
            "e" = "exit";
            "s" = "exec systemctl poweroff";
            "r" = "exec systemctl reboot";
            "h" = "exec systemctl hibernate";
            "Return" = "mode 'default'";
            "Escape" = "mode 'default'";
          };
        };
      };

      extraConfig = ''
        corner_radius 6
        smart_corner_radius enable
        shadows enable
        shadows_on_csd enable
        default_dim_inactive 0.14
      '';

      # set $background_video ~/.config/sway/bg.mp4
      # set $mpvpaper_params --auto-pause --mpv-options "no-audio --loop-file"
    };
  };
}
