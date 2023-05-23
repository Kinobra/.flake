{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myPrograms.waybar;

  waybar-custom-cpu = pkgs.writeTextFile {
    name = "waybar-custom-cpu";
    destination = "/bin/waybar-custom-cpu";
    executable = true;
    text = ./waybar-custom-cpu.sh;
  };

  waybar-custom-gpu = pkgs.writeTextFile {
    name = "waybar-custom-gpu";
    destination = "/bin/waybar-custom-gpu";
    executable = true;
    text = ./waybar-custom-gpu.sh;
  };
in {
  options.myPrograms.waybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      waybar-custom-cpu
      waybar-custom-gpu

      ripgrep
      nvtop-amd
      pulsemixer
      lm_sensors		# Tools for reading hardware sensors
      bottom			# Yet another cross-platform graphical process/system monitor
      # libappindicator-gtk3
    ];

    home.programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";

          modules-left = [ "custom/menu" "sway/workspaces" "sway/mode" "sway/window" ];
          modules-center = [ "clock" ];
          modules-right = [
            (optionalString (builtins.elem config.networking.hostName ["nixos" "minerva"]) "custom/cpu")
            (optionalString (builtins.elem config.networking.hostName ["nixos"]) "custom/gpu")
            (optionalString (builtins.elem config.networking.hostName ["minerva"]) "battery")
            "tray" "pulseaudio" "network" ];

          "custom/menu" = {
            format = "Λ";
            on-click = "swaymsg exec \\$menu";
            tooltip = false;
          };
          "sway/mode" = {
            format = "{}";
            tooltip = false;
          };
          "sway/window" = {
            format = "{title}";
            max-length = 50;
            rewrite = {
              "(.*)Discord" = "Discord";
              "(.+)" = "| $1 ";
              "" = "";
            };
          };

          "clock" = {
              interval = 60;
              format = "{:%b %e %Y %H:%M}";
              tooltip = true;
              tooltip-format = "<big>{:%B %Y}</big>\n<tt>{calendar}</tt>";
          };

          "custom/cpu" = {
              interval = 1;
              format = "<span color=\"gray\">CPU</span> {}";
              exec = "waybar-custom-cpu";
              on-click = "swaymsg exec \"${config.home.sessionVariables.TERM} --class=floating -e btm\"";
          };
          "custom/gpu" = {
              interval = 1;
              format = "<span color=\"gray\">GPU</span> {}";
              exec = "waybar-custom-gpu";
              on-click = "swaymsg exec \"${config.home.sessionVariables.TERM} --class=floating -e nvtop\"";
          };
          "battery" = {
            format = "<span color=\"gray\">BAT</span> {capacity}%";
          };

          "tray" = {
              icon-size = 18;
              spacing = 5;
              reverse-direction = true;
          };

          "pulseaudio" = {
              scroll-step = 5;
              format = "<span color=\"gray\">VOL</span> {volume}%";
              format-muted = "<span strikethrough=\"true\" color=\"gray\">VOL</span>";
              tooltip-format = "VOL {volume}%";
              on-click = "swaymsg exec \"${config.home.sessionVariables.TERM} --class=floating -e pulsemixer\"";
          };
          "network" = {
              interval = 5;
              format-wifi = "<span color=\"gray\">WIFI</span>";
              format-ethernet = "<span color=\"gray\">ETH</span>";
              format-disconnected = "<span strikethrough=\"true\" color=\"gray\">ETH</span>";
              tooltip-format = "{ifname} ({essid}): {ipaddr}";
              on-click = "swaymsg exec \"${config.home.sessionVariables.TERM} --class=floating -e nmtui\"";
          };
        };
      };
      style = let
        margin = 6;
        border-radius = 6;
        padding-vertical = 2;
        padding-horizontal = 4;
        padding-inner = 4;
        unit = "px";
      in ''
        * {
          color: #dddddd;
          font-family: "Fira Code Semibold";
          font-size: 16px;

          border: none;
          border-radius: ${toString border-radius}${unit};

          padding: 0px 0px 0px 0px;
          margin: 0px 0px 0px 0px;
        }

        #waybar {
          background: transparent;
        }

        .modules-left,
        .modules-center,
        .modules-right {
          margin:
            ${toString margin}${unit}
            ${toString margin}${unit}
            0px
            ${toString margin}${unit};
          background-color: #121212;
        }
        .modules-left {
          padding-right: ${toString padding-horizontal}${unit};
        }
        .modules-right {
          padding-left: ${toString padding-horizontal}${unit};
        }

        #mode,
        #custom-cpu,
        #custom-gpu,
        #battery
        {
          padding:
            ${toString padding-vertical}${unit}
            ${toString padding-inner}${unit}
            ${toString padding-vertical}${unit}
            ${toString padding-inner}${unit};
        }

        #custom-menu {
          background-color: black;
          border-radius:
            ${toString border-radius}${unit}
            0px
            0px
            ${toString border-radius}${unit};
          padding:
            ${toString padding-vertical}${unit}
            ${toString (padding-horizontal + padding-inner)}${unit}
            ${toString padding-vertical}${unit}
            ${toString (padding-horizontal + padding-inner)}${unit};
        }
        #workspaces button {
          padding:
            ${toString padding-vertical}${unit}
            2px
            ${toString padding-vertical}${unit}
            ${toString padding-inner}${unit};
        }
        #workspaces button.focused { background-color: #424242; }

        #clock {
          padding:
            ${toString padding-vertical}${unit}
            ${toString (padding-horizontal + padding-inner)}${unit}
            ${toString padding-vertical}${unit}
            ${toString (padding-horizontal + padding-inner)}${unit};
        }

        #tray {
          padding:
            ${toString padding-vertical}${unit}
            ${toString padding-inner}${unit}
            ${toString padding-vertical}${unit}
            ${toString padding-inner}${unit};
        }
        #pulseaudio {
          border-radius: 0px 0px 0px 0px;
          padding:
            ${toString padding-vertical}${unit}
            ${toString padding-inner}${unit}
            ${toString padding-vertical}${unit}
            ${toString padding-inner}${unit};
        }
        #network {
          border-radius:
            0px
            ${toString border-radius}${unit}
            ${toString border-radius}${unit}
            0px;
          padding:
            ${toString padding-vertical}${unit}
            ${toString (padding-horizontal + padding-inner)}${unit}
            ${toString padding-vertical}${unit}
            ${toString padding-inner}${unit};
        }
        #pulseaudio, #network {
          background-color: black;
        }
      '';
    };

    home.sessionVariables = {
      BAR="waybar";
    };    
    home.programs.nushell.extraEnv = mkIf config.myPrograms.nushell.enable ''
      let-env BAR = waybar
    '';
  };
}
