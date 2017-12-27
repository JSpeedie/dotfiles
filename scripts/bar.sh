. ~/coloursconf

MAX_SONG_LEN=24;

echo "" > .barOut

let number_of_monitors=$(xrandr | grep " connected" | awk '{print $1}' | wc -l)
screen_full_dims=$(xrandr | grep "eDP-1" | \
	head -n 1 | grep -o "[0-9]\+x[0-9]\++[0-9]\++[0-9]\+")
# Dimensions for bar (returns full dimensions of largest (resolution wise)
# monitor in setup in an "1920x1080" kind of format)
screen_w_and_h=$(echo "$screen_full_dims" | grep -o "[0-9]\+x[0-9]\+")
screen_x_and_y=$(echo "$screen_full_dims" | grep -o "+[0-9]\++[0-9]\+")
screen_w=$(echo "$screen_w_and_h" | sed "s/x.*$//")
screen_h=$(echo "$screen_w_and_h" | sed "s/^.*x//")
screen_x=$(echo "$screen_x_and_y" | sed "s/+.*$//")
screen_y=$(echo "$screen_x_and_y" | sed "s/^.*+//")

# monitor width divided by 2 plus the shift - half the width of the bar
bar_x=$(echo "$screen_x")
echo "bar_x $bar_x" >> .barOut
let bar_y=0

let combi=0
# If mpd is running
if [[ $(mpc > /dev/null 2>&1; echo "$?") == 0 ]]; then
	song=$(mpc current)
else
	song=""
fi

# Fonts
siji10="-wuncon-siji-medium-r-normal--10-100-75-75-c-80-iso10646-1"
siji17="-wuncon-siji-medium-r-normal--17-120-100-100-c-80-iso10646-1"
tamzen="-*-tamzen-medium-*-*-*-17-*-*-*-*-*-*-*"
text_colour=$color7
highlight_colour=$color6

# Separators
sep2="  "
sep3="   "
sep4="    "
bar_sep=$sep2

# Icons
# icon_wksp="\ue001"
icon_wksp="\ue130"
icon_wksp_sel="\ue000"
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
		bat_dir=""
	fi

	# If a battery directory was found
	if [[ $bat_dir != "" ]]; then
		stat=$(cd $bat_dir; cat status)
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

		echo -e "%{F$highlight_colour}$stat%{F-} ${perc}"
	else
		echo ""
	fi
}

brightness() {
	# acpi_video0 is used for ati graphics card (amd cpu with no ded gpu?)
	if [[ -f /sys/class/backlight/intel_backlight/brightness ]]; then
		bright=$(cat /sys/class/backlight/intel_backlight/brightness)
		max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
		bright=$(echo "$bright $max" | awk '{printf "%.0f\n", ($1/$2) * 100}')
		bright+="%"
		echo -e "%{F$highlight_colour}$icon_brightness%{F-} $bright"
	elif [[ -f /sys/class/backlight/acpi_video0/brightness ]]; then
		bright=$(cat /sys/class/backlight/acpi_video0/brightness)
		max=$(cat /sys/class/backlight/acpi_video0/max_brightness)
		bright=$(echo "$bright $max" | awk '{printf "%.0f\n", ($1/$2) * 100}')
		bright+="%"
		echo -e "%{F$highlight_colour}$icon_brightness $bright%{F-}"
	else
		echo ""
	fi
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

	echo -e "%{F$highlight_colour}$icon%{F-} $vol"
}

current_date() {
	# Shortened day of week, mon and day
	echo "%{F$highlight_colour}$icon_date%{F-} $(date "+%a %m/%d")"
}

current_time() {
	echo "%{F$highlight_colour}$icon_time%{F-} $(date +%I:%M:%S)"
}

mem() {
	echo "%{F$highlight_colour}$icon_memory%{F-} $(free --mega | awk 'NR==2 {print $3}').\
		$(free --mega | awk 'NR==2 {print $7}')"
}

song() {
	# If mpd is running
	if [[ $(mpc > /dev/null 2>&1; echo "$?") == 0 ]]; then
		song_len=$MAX_SONG_LEN
		if [[ ${#song} -lt $MAX_SONG_LEN ]]; then
			let song_len=${#song}+${#sep4}
		fi

		scr_text_combin=$(sh ~/scripts/scrolltext.sh "$song" $1 $song_len)

		if [[ $(mpc status | grep "playing") ]]; then
			echo "%{F$highlight_colour}$icon_music_playing%{F-} $scr_text_combin"
		elif [[ $(mpc status | grep "paused") ]]; then
			echo "%{F$highlight_colour}$icon_music_paused%{F-} $scr_text_combin"
		else
			echo ""
		fi
	else
		echo ""
	fi
}

cpu_temp() {
	temp=$(sensors | grep id | grep -o "[0-9]\+\.[0-9]" | head -n 1)
	echo "%{F$highlight_colour}$icon_cpu_temp%{F-} $temp"
}

workspaces() {
	status=$(bspc wm -g | tr ':' '\n' | grep -o "^[oOfF]")
	out=""

	for wksp in $status; do
		if [[ $wksp == "O" ]] || [[ $wksp == "F" ]]; then
			out+="%{F$highlight_colour}$icon_wksp_sel%{F-}$bar_sep"
		else
			out+="$icon_wksp$bar_sep"
		fi
	done

	echo -e "$out"
}

while true; do
	final_song=$(song $combi)
	final_bat=$(battery)
	final_brightness=$(brightness)
	bat_sep=""
	brightness_sep=""
	bar_out=""
	# If mpd is active, add the extra spacing
	if [[ $final_song != "" ]]; then
		final_song+=$sep4
	fi
	# If the system has a battery
	if [[ $final_bat != "" ]]; then bat_sep=$bar_sep; fi
	# If the system has built in screen with brightness
	if [[ $final_brightness != "" ]]; then brightness_sep=$bar_sep; fi

	bar="%{l}$bar_sep$(workspaces)\
		%{c}$(current_time)$bar_sep$(volume)$bar_sep${final_song}\
		%{r}$(cpu_temp)$bar_sep$(mem)$bar_sep${brightness}$brightness_sep\
		${final_bat}$bat_sep$(current_date)$bar_sep"

	let mon_number=0
	while [[ $mon_number -lt $number_of_monitors ]]; do
		bar_out+="%{S$mon_number}$bar"
		let mon_number=$mon_number+1
	done

	echo "$bar_out"

	if [[ $(mpc > /dev/null 2>&1; echo "$?") == 0 ]]; then
		song=$(mpc current)

		# Increment combi. Modulus combi.
		if [[ ${#song} -ne 0 ]]; then
			let combi=$combi+1
			let combi=$combi%MAX_SONG_LEN
		fi
	fi
	sleep 0.5s
done | lemonbar -g ${bar_width}x30+${bar_x}+${bar_y} -B $color0 -F \
	$text_colour -p -o -3 -f $siji10 -o 0 -f $tamzen &
