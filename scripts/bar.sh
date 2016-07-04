. ~/coloursconf

# Get Dimensions
let bar_width=800
# Dimensions for bar (returns full dimensions of $DISPLAY in an "1920x1080"
# kind of format
screen_x_and_y=$(xrandr | grep Screen | grep -o "current [0-9]\+ x [0-9]\+" | \
	sed "s/ \|current//g")
screen_x=$(echo "$screen_x_and_y" | sed "s/x.*$//")
screen_y=$(echo "$screen_x_and_y" | sed "s/^.*x//")

let bar_x=$(echo "$bar_width $screen_x" | awk '{print  ($2/2)-($1/2)}')
let bar_y=0

# Fonts
siji10="-wuncon-siji-medium-r-normal--10-100-75-75-c-0-iso10646-1"
siji17="-wuncon-siji-medium-r-normal--17-120-100-100-c-0-iso10646-1"
tamzen="-*-tamzen-medium-*-*-*-17-*-*-*-*-*-*-*"
# Separators
sep4="    "
# Icons
icon_up_time=""
icon_net=''
icon_memory=""
icon_cpu_temp=""
IVolMuted=""
IVolLow=""
icon_vol_high=""
icon_battery_charging=""
icon_date=""
icon_time=""
IBrightness=""

battery() {
	stat="$icon_battery_charging"
	if [[ -d /sys/class/power_supply/BAT0 ]]; then
		stat=$(cat /sys/class/power_supply/BAT0/status)
	elif [[ -d /sys/class/power_supply/BAT1 ]]; then
		stat=$(cat /sys/class/power_supply/BAT1/status)
		if [[ $stat == "Unknown" ]] || [[ $stat == "Charging" ]] || [[ $stat == "Full" ]]; then
			stat="$icon_battery_charging"
		else
			perc=$(cat /sys/class/power_supply/BAT1/capacity)
			if [[ $perc -ge 90 ]]; then stat="\ue24b"
			elif [[ $perc -ge 80 ]]; then stat="\ue24a"
			elif [[ $perc -ge 70 ]]; then stat="\ue249"
			elif [[ $perc -ge 60 ]]; then stat="\ue248"
			elif [[ $perc -ge 50 ]]; then stat="\ue247"
			elif [[ $perc -ge 40 ]]; then stat="\ue246"
			elif [[ $perc -ge 30 ]]; then stat="\ue245"
			elif [[ $perc -ge 20 ]]; then stat="\ue244"
			elif [[ $perc -ge 10 ]]; then stat="\ue243"
			else stat="\ue242"; fi

			echo -e "%{F$color1}$stat ${perc}%%{F-}"
		fi
	else
		echo -e "%{F$color1}$stat 999%%{F-}"
	fi
}

brightness() {
	# acpi_video0 is used for ati graphics card (amd cpu with no ded gpu?)
	if [[ -f /sys/class/backlight/intel_backlight/brightness ]]; then
		bright=$(cat /sys/class/backlight/intel_backlight/brightness)
		max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
		bright=$(echo "$bright $max" | awk '{print $1/$2 * 100}' | grep -o "^.\{,3\}" )
		bright+="%"
		echo "%{F$yellow}$icon_brightness $bright%{F-}"
	else
		echo "u fuk"
	fi
}


up_time() {
	up=$(awk '{print $1 / 86400}' /proc/uptime | grep -o ".*\..\{0,3\}")
	echo "%{F$color1}$icon_up_time $up%{F-}"
}

volume() {
	echo "%{F$color4}$icon_vol_high $(pamixer --get-volume)%{F-}"
}

current_date() {
	# Shortened day of week, mon and day
	echo "%{F$color2}$icon_date $(date "+%a %m/%d")%{F-}"
}

current_time() {
	# 24 hour clock
	echo "%{F$color3}$icon_time $(date +%T)%{F-}"
}

mem() {
	echo "%{F$color4}$icon_memory $(free --mega | awk 'NR==2 {print $3}')%{F-}"
}

cpu_temp() {
	temp=$(sensors | grep id | grep -o "[0-9]\+\.[0-9]" | head -n 1)
	echo "%{F$color5}$icon_cpu_temp $temp%{F-}"
}

net() {
	gate=$(ip r | grep default | cut -d ' ' -f 3)
	if [[ ${#gate} -ge 7 ]]; then
		if [[ $(ping -q -w 1 -c 1 $gate) ]]; then
			echo "%{F$color8}$icon_net%{F-}"
		else
			echo ""
		fi
	else
		echo ""
	fi
}

while true; do
	echo "%{c}$sep4$(brightness)$sep4$(up_time)$sep4$(cpu_temp)$sep4$(mem)$sep4$(net)\
			$sep4$(volume)$sep4$(current_date)$sep4$(current_time)$sep4$(battery)$sep4"
	sleep 0.5s
done | lemonbar -g ${bar_width}x30+${bar_x}+${bar_y} -B $color0 -p -o -3 -f $siji10 -o 0 -f $tamzen &
