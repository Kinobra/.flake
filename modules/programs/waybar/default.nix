{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myPrograms.waybar;

  waybar-custom-cpu = pkgs.writeTextFile {
    name = "waybar-custom-cpu";
    destination = "/bin/waybar-custom-cpu";
    executable = true;
    text = ''
      load=$(expr 100 - $(vmstat 1 2|tail -1|awk '{print $15}'))%

      Memtotal=$(cat /proc/meminfo | rg "^MemTotal:" | sed -E 's/\S*\s*//' | sed -E 's/ kB//')
      Shmem=$(cat /proc/meminfo | rg "^Shmem:" | sed -E 's/\S*\s*//' | sed -E 's/ kB//')
      MemFree=$(cat /proc/meminfo | rg "^MemFree:" | sed -E 's/\S*\s*//' | sed -E 's/ kB//')
      Buffers=$(cat /proc/meminfo | rg "^Buffers:" | sed -E 's/\S*\s*//' | sed -E 's/ kB//')
      Cached=$(cat /proc/meminfo | rg "^Cached:" | sed -E 's/\S*\s*//' | sed -E 's/ kB//')
      SReclaimable=$(cat /proc/meminfo | rg "^SReclaimable:" | sed -E 's/\S*\s*//' | sed -E 's/ kB//')
      # mem=$(awk "BEGIN {print (($Memtotal + $Shmem - $MemFree - $Buffers - $Cached - $SReclaimable)/$Memtotal)*100}" | sed 's/\..*//')%
      mem=$(awk "BEGIN {print ($Memtotal + $Shmem - $MemFree - $Buffers - $Cached - $SReclaimable)/1024}" | sed 's/\..*//')M

      if [ -e /sys/class/hwmon/hwmon2/temp1_input ]; then
        # temp=$(($(cat /sys/class/hwmon/hwmon2/temp1_input) / 1000))C
        temp=$(awk "BEGIN {print ($(cat /sys/class/hwmon/hwmon2/temp1_input) / 1000 + 273.15)}" | sed 's/\..*//')K
        echo $load $mem $temp
      elif [ -e /sys/class/hwmon/hwmon1/temp1_input ]; then
        # temp=$(($(cat /sys/class/hwmon/hwmon1/temp1_input) / 1000))C
        temp=$(awk "BEGIN {print ($(cat /sys/class/hwmon/hwmon1/temp1_input) / 1000 + 273.15)}" | sed 's/\..*//')K
        echo $load $mem $temp
      else
        echo "!"
      fi
    '';
  };

  waybar-custom-gpu = pkgs.writeTextFile {
    name = "waybar-custom-gpu";
    destination = "/bin/waybar-custom-gpu";
    executable = true;
    text = ''
      # https://wiki.archlinux.org/title/AMDGPU#Manually
      # GPU's P-states: cat /sys/class/drm/card0/device/pp_od_clk_voltage
      # Monitor GPU: watch -n 0.5  cat /sys/kernel/debug/dri/0/amdgpu_pm_info
      # GPU utilization: cat /sys/class/drm/card0/device/gpu_busy_percent
      # GPU frequency: cat /sys/class/drm/card0/device/pp_dpm_sclk
      # GPU temperature: cat /sys/class/drm/card0/device/hwmon/hwmon*/temp1_input
      # VRAM frequency: cat /sys/class/drm/card0/device/pp_dpm_mclk
      # VRAM usage: cat /sys/class/drm/card0/device/mem_info_vram_used
      # VRAM size: cat /sys/class/drm/card0/device/mem_info_vram_total

      gpu_path="/sys/class/drm/card0/device"
      
      if [ -e $gpu_path/gpu_busy_percent ] && [ -e $gpu_path/mem_info_vram_used ] && [ -e $gpu_path/mem_info_vram_total ] && [ -e $gpu_path/hwmon/hwmon*/temp1_input ]
      then
        load=$(cat $gpu_path/gpu_busy_percent)%

        mem_info_vram_used=$(cat $gpu_path/mem_info_vram_used)
        mem_info_vram_total=$(cat $gpu_path/mem_info_vram_total)
        # mem=$(awk "BEGIN {print ($mem_info_vram_used / $mem_info_vram_total) * 100}" | sed 's/\..*//')%
        mem=$(awk "BEGIN {print $mem_info_vram_used / (1024 * 1024)}" | sed 's/\..*//')M

        temp=$(cat $gpu_path/hwmon/hwmon*/temp1_input)
        # temp=$(expr $temp / 1000)C
        temp=$(awk "BEGIN {print ($temp / 1000 + 273.15)}" | sed 's/\..*//')K

        echo $load $mem $temp
      else
        echo "!"
      fi

    '';
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

          modules-left = [ "custom/menu" "sway/workspaces" "sway/window" "sway/mode" ];
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
          "sway/window" = {
            format = "{title}";
            max-length = 50;
            rewrite = {
              "(.*)Discord" = "Discord";
              "(.+)" = "| $1";
              # "" = "| None";
            };
          };
          "sway/mode" = {
            format = "<span style=\"italic\">{}</span>";
            tooltip = false;
          };

          "clock" = {
              interval = 60;
              format = "{:%b %e %Y %H:%M}";
              tooltip = true;
              tooltip-format = "<big>{:%B %Y}</big>\n<tt>{calendar}</tt>";
          };

          "custom/cpu" = {
              interval = 1;
              format = " <span color=\"gray\">CPU</span> {}";
              exec = "waybar-custom-cpu";
              on-click = "swaymsg exec \"kitty --class=floating btm\"";
          };
          "custom/gpu" = {
              interval = 1;
              format = "<span color=\"gray\">GPU</span> {}";
              exec = "waybar-custom-gpu";
              on-click = "swaymsg exec \"kitty --class=floating nvtop\"";
          };
          "battery" = {
            format = " <span color=\"gray\">BAT</span> {capacity}%";
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
              on-click = "swaymsg exec \"kitty --class=floating pulsemixer\"";
          };
          "network" = {
              interval = 5;
              format-wifi = "<span color=\"gray\">WIFI</span>";
              format-ethernet = "<span color=\"gray\">ETH</span>";
              format-disconnected = "<span strikethrough=\"true\" color=\"gray\">ETH</span>";
              tooltip-format = "{ifname} ({essid}): {ipaddr}";
              on-click = "swaymsg exec \"kitty --class=floating nmtui\"";
          };
        };
      };
      style = ''
        * {
            color: #dddddd;
            font-family: "Fira Code Semibold";
            font-size: 16px;

            border: none;
            border-radius: 8px;

            padding: 0px 0px 0px 0px;
            margin: 0px 0px 0px 0px;
        }

        /* The whole bar */
        #waybar {
            background: transparent;
        }

        .modules-left,
        .modules-center,
        .modules-right {
            margin-top: 6px;
            background-color: #121212;
            padding: 2px 2px 2px 2px;
        }
        .modules-left {
            margin-left: 8px;
        }
        .modules-right {
            margin-right: 8px;
        }

        /* Each module */
        #custom-menu,
        /* #workspaces, */
        #workspaces button,
        #mode,
        #window,
        #clock,
        #cpu,
        #custom-gpu,
        #memory,
        #temperature,
        #tray,
        #pulseaudio,
        #network {
            padding-left: 8px;
            padding-right: 8px;
        }

        /*custom/menu*/
        #custom-menu {
            background-color: black;
            border-radius: 4px 0px 0px 4px;
        }

        #workspaces button {
            padding: 0px 2px 0px 4px;
        }
        #workspaces button.focused {
            background-color: #424242;
        }

        /* sway/mode */
        #window {
            padding-left: 0;
        }

        #pulseaudio, #network {
            color: #dedede;
            background-color: black;
            margin: 0px;
        }
        #pulseaudio {
            border-radius: 0px 0px 0px 0px;
        }
        #network {
            border-radius: 0px 4px 4px 0px;
            margin-right: 2px;
        }
      '';
    };
  };
}
