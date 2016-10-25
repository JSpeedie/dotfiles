. ~/coloursconf

echo "" > .barOut

# Get Dimensions
let bar_width=1200
# Returns the dimensions of all the monitors in your setup in a
# 2560x1440
# 1920x1080
# format
monitor_dims=$(xrandr | grep " connected" | grep -o "[0-9]\+x[0-9]\+")

monitor_with_largest_dims=$(echo "$monitor_dims" | head -n 1)
max=0
for monitor in $monitor_dims; do
	pixels=$(echo "$monitor" | sed "s/x/ /" | awk '{print ($1 * $2)}')
	if [[ $pixels -gt $max ]]; then
		max=$pixels
		monitor_with_largest_dims=$monitor
	fi
done

echo "monitor_with_largest_dims $monitor_with_largest_dims" >> .barOut

screen_full_dims=$(xrandr | grep "$monitor_with_largest_dims" | \
	head -n 1 | grep -o "[0-9]\+x[0-9]\++[0-9]\++[0-9]\+")
# Dimensions for bar (returns full dimensions of largest (resolution wise)
# monitor in setup in an "1920x1080" kind of format)
screen_x_and_y=$(echo "$screen_full_dims" | grep -o "[0-9]\+x[0-9]\+")
screen_x_and_y_shift=$(echo "$screen_full_dims" | grep -o "[0-9]\++[0-9]\+$")
screen_x=$(echo "$screen_x_and_y" | sed "s/x.*$//")
echo "screen_x $screen_x" >> .barOut
screen_y=$(echo "$screen_x_and_y" | sed "s/^.*x//")
screen_x_shift=$(echo "$screen_x_and_y_shift" | sed "s/+.*$//")
echo "screen_x_shift $screen_x_shift" >> .barOut
screen_y_shift=$(echo "$screen_x_and_y_shift" | sed "s/^.*+//")
screen_y=$(echo "$screen_y $screen_y_shift" | awk '{print ($1 + $2)}')

# monitor width divided by 2 plus the shift - half the width of the bar
let bar_x=$(echo "$screen_x $screen_x_shift $bar_width" | \
			awk '{print ((($1 / 2) + $2) - ($3 / 2))}')
echo "bar_x $bar_x" >> .barOut
let bar_y=0

let combi=0
song=$(mpc current)

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
# Icons are (in order) , , 
icon_vol_muted="\ue04f"
icon_vol_low="\ue04e"
icon_vol_high="\ue050"
# Icons are (in order) , (tba)
icon_battery_charging="\ue20e"
icon_battery_full="\ue24b"
icon_date=""
icon_time=""
icon_music_paused=""
icon_music_playing=""
# Icon is 
icon_brightness="\ue0a9"

# Needs to be tested on a machine with no battery
battery() {
	if [[ -d /sys/class/power_supply/BAT0 ]]; then
		bat_dir="/sys/class/power_supply/BAT0"
	elif [[ -d /sys/class/power_supply/BAT1 ]]; then
		bat_dir="/sys/class/power_supply/BAT1"
	else
		echo ""
	fi

	perc=$(cd $bat_dir; paste energy_now energy_full |
			awk '{printf "%.1f\n", ($1/$2) * 100}')

	if [[ $stat == "Unknown" ]] || [[ $stat == "Charging" ]]; then
		stat="$icon_battery_charging"
	elif [[ $stat == "Full" ]]; then
		stat="$icon_battery_full"
	else
		status=("\ue242" "\ue243" "\ue244" "\ue245" "\ue246" "\ue247" "\ue248" "\ue249" "\ue24a" "\ue24b")
		echo "#status = ${#status[@]}" >> .barOut

		icon_number=$(echo "$perc ${#status[@]}" | \
			awk '{printf "%.0f\n", $1 / (100 / ($2 - 1))}')
		echo "icon_number = $icon_number" >> .barOut

		stat="${status[$icon_number]}"
	fi

	echo -e "%{F$color1}$stat ${perc}%{F-}"
}

brightness() {
	# acpi_video0 is used for ati graphics card (amd cpu with no ded gpu?)
	if [[ -f /sys/class/backlight/intel_backlight/brightness ]]; then
		bright=$(cat /sys/class/backlight/intel_backlight/brightness)
		max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
		bright=$(echo "$bright $max" | awk '{printf "%.0f\n", ($1/$2) * 100}')
		bright+="%"
		echo -e "%{F$color3}$icon_brightness $bright%{F-}"
	elif [[ -f /sys/class/backlight/acpi_video0/brightness ]]; then
		bright=$(cat /sys/class/backlight/acpi_video0/brightness)
		max=$(cat /sys/class/backlight/acpi_video0/max_brightness)
		bright=$(echo "$bright $max" | awk '{printf "%.0f\n", ($1/$2) * 100}')
		bright+="%"
		echo -e "%{F$color3}$icon_brightness $bright%{F-}"
	else
		echo ""
	fi
}


up_time() {
	up=$(awk '{printf "%.2f\n", $1 / 86400}' /proc/uptime)
	echo "%{F$color1}$icon_up_time $up%{F-}"
}

volume() {
	vol=$(pamixer --get-volume)

	if [[ $(pamixer --get-mute) == "true" ]]; then
		icon=$icon_vol_muted
	else
		if [[ $vol -ge 50 ]]; then
			icon=$icon_vol_high
		else
			icon=$icon_vol_low
		fi
	fi

	echo -e "%{F$color4}$icon $vol%{F-}"
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

song() {
	scr_text_combin=$(sh ~/scripts/scrolltext2.sh 14 "$song   " $1)

	if [[ $(mpc status | grep "playing") ]]; then
		printf "combi $1\n" >> combi

		echo "%{F$color1}$icon_music_playing $scr_text_combin%{F-}"
	elif [[ $(mpc status | grep "paused") ]]; then
		# let combi=$(echo "$combi 10" | awk '{print ($1 + 1) % $2}')
		printf "combi $1\n" >> combi

		echo "%{F$color1}$icon_music_paused $scr_text_combin%{F-}"
	else
		echo ""
	fi

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
	final_song=$(song $combi)
	# If mpd is active, add the extra spacing
	if [[ $final_song != "" ]]; then
		final_song+=$sep4
	fi

	echo "%{c}$sep4$(brightness)$sep4$(up_time)$sep4$(cpu_temp)$sep4$(mem)\
			$sep4$(net)$sep4$(volume)$sep4$(current_date)$sep4$(current_time)\
			$sep4${final_song}$(battery)$sep4"
	song=$(mpc current)
	# Increment combi. Modulus combi.
	if [[ ${#song} -ne 0 ]]; then
		let combi=$combi+1
		let combi=$combi%${#song}
	fi
	sleep 0.5s
done | lemonbar -g ${bar_width}x30+${bar_x}+${bar_y} -B $color0 -p -o -3 \
	-f $siji10 -o 0 -f $tamzen &
