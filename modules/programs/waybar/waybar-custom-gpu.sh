#!/bin/sh

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
