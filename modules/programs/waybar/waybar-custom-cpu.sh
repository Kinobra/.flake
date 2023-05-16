#!/bin/sh

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
