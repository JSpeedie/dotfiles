#!/bin/bash

# Colours, Icons and Separators {{{
# Colours
. ~/coloursconf

# Icons
# IUpTime=""
IUpTime=""
# INet='\ue222'
INet=''
# IMem=""
IMem=""
# ICpuTemp=""
ICpuTemp=""
ICpuLoad=""
# IVolMuted=""
# IVolLow=""
# IVolHigh=""
IVolMuted=""
IVolLow=""
IVolHigh=""

# Battery Icons
IBattery0=""
IBattery1=""
IBattery2=""
IBattery3=""
IBattery4=""
IBatteryCharging=""

# IDate=""
IDate=""
# ITime=""
ITime=""
ILock=""
# IBrightness=""
IBrightness=""

# Workspace Icons
# IWorkspaceFocused=""
IWorkspaceFocused=""
# IWorkspaceUnfocused=""
IWorkspaceUnfocused=""
# IWorkspaceEmpty=""
IWorkspaceEmpty=""
IMonitorDivider="|"

# Separators
SEP=" "
SEP2="  "
SEP4="    "
SEP6="      "
# }}}

# Other stuff
siji10="-wuncon-siji-medium-r-normal--10-100-75-75-c-0-iso10646-1"
siji17="-wuncon-siji-medium-r-normal--17-120-100-100-c-0-iso10646-1"
tamzen="-*-tamzen-medium-*-*-*-17-*-*-*-*-*-*-*"
refresh=0.5
fg=$base00
bg=$base05
gray=$base0C

# Create temp files
# mkdir -p /tmp/.lemonbarscripts
# echo "false" >/tmp/.lemonbarscripts/cputnotif
# echo "false" >/tmp/.lemonbarscripts/batterynotif

# Names of all the screen outputs being used
Screens=$(xrandr | sed -n "s/ connected.*$//p")

bar() {

	# Reading multiple files, many if statements and notifications. Needs work.
	Battery() {
		# If this system has a battery
		if [[ -d /sys/class/power_supply/BAT0 ]] || [[ -d /sys/class/power_supply/BAT1 ]]; then
			# Can be 'Full', 'Discharging', 'Unknown' or 'Charging'.
			# Unknown sometimes means charging on my laptop???
			STATUS=$(cat /sys/class/power_supply/BAT0/status || cat /sys/class/power_supply/BAT1/status)
			# Notifications {{{
			# If battery is less than 15 (low imo) send a notification
			# if [[ $BATTERY -lt 15 ]]; then
				# NOTIF=$(cat /tmp/.lemonbarscripts/batterynotif)
				# If the user has not been notified about the battery being low
				# if [[ $NOTIF == "false" ]]; then
					# Sends a notification to their notification client. I use dunst
					# notify-send "Low battery" -u critical
					# change the text in the file to say true so we know in the
					# future to not notify them again too quickly (to avoid spam)
					# echo "true" >/tmp/.lemonbarscripts/batterynotif
				# fi
			# cpu temps are low so re-allow sending the notification
			# elif [[ $BATTERY -gt 15 ]]; then
				# echo "false" >/tmp/.lemonbarscripts/batterynotif
			# fi
			# }}}
			BATTERY=$(cat /sys/class/power_supply/BAT0/capacity || cat /sys/class/power_supply/BAT1/capacity)
			if [[ $STATUS == "Unknown" ]] || [[ $STATUS == "Charging" ]] || [[ $STATUS == "Full" ]]; then
				stat="";
			else
				if [[ $BATTERY -ge 90 ]]; then stat="\ue24b"
				elif [[ $BATTERY -ge 80 ]]; then stat="\ue24a"
				elif [[ $BATTERY -ge 70 ]]; then stat="\ue249"
				elif [[ $BATTERY -ge 60 ]]; then stat="\ue248"
				elif [[ $BATTERY -ge 50 ]]; then stat="\ue247"
				elif [[ $BATTERY -ge 40 ]]; then stat="\ue246"
				elif [[ $BATTERY -ge 30 ]]; then stat="\ue245"
				elif [[ $BATTERY -ge 20 ]]; then stat="\ue244"
				elif [[ $BATTERY -ge 10 ]]; then stat="\ue243";
				else stat="\ue242"; fi
			fi
			BATTERY+="%"
			echo -e %{F$gray}$stat$SEP$BATTERY%{F-}
		else
			echo ""
		fi
	}

	# Approved
	Brightness() {
		BRIGHTNESS=$(xbacklight -get | grep -o "[0-9]\+\.[0-9]\?")
		if [[ $BRIGHTNESS != "" ]]; then
			BRIGHTNESS+="%"
			echo %{F$gray}$IBrightness$SEP$BRIGHTNESS%{F-}
		else
			echo ""
		fi
	}

	# Ok. few pipes so prob ok
	CpuTemp() {
		# Get the the highest temp of any core
		CPUTEMP=$(sensors | grep "Physical id" | grep -o "[0-9]\+\.[0-9]\+" | head -n 1 | sed "s/\..*$//")
			# Notifications {{{
			# if [[ $CPUTEMP -gt 65 ]]; then
				# NOTIF=$(cat /tmp/.lemonbarscripts/cputnotif)
				# If the user has not been notified about the cpu temp being high
				# if [[ $NOTIF != "true" ]]; then
					# Sends a notification to their notification client. I use dunst
					# notify-send "High cpu temps"
					# change the text in the file to say true so we know in the
					# future to not notify them again too quickly (to avoid spam)
					# echo "true" >/tmp/.lemonbarscripts/cputnotif
				# fi
			# cpu temps are low so reallow sending the notification
			# else echo "false" >/tmp/.lemonbarscripts/cputnotif; fi
			# }}}
		CPUTEMP+="C"
		echo -e %{F$color2}$ICpuTemp$SEP$CPUTEMP%{F-}
	}

	# Approved
	Date() {
		DATE=$(date "+%a %m/%d")
		echo %{F$gray}$IDate$SEP$DATE%{F-}
	}

	# Approved
	Memory() {
		MEMUSED=$(free -m | awk 'NR==2 {print $3}')
		MEMUSED+="MB"
		echo %{F$color3}$IMem$SEP$MEMUSED%{F-}
	}

	# Ok
	NetUp() {
		# Pings the default gateway. If it is successful then we are connected. Benefits
		# to pinging the default gateway rather than google.com, etc. is that this doesn't
		# rely on those websites being up and as such, will always be accurate
		defGate=$(ip r | grep default | cut -d ' ' -f 3)
		# 7 is the minimum length for a valid ip address (ex. 1.1.1.1)
		# Really just used to make sure we obtained a valid ip from 'ip r'
		if [[ ${#defGate} -ge 7 ]]; then
			NetUp=$(ping -q -w 1 -c 1 $defGate > /dev/null && echo c || echo u)
			# If some network interface is up
			if [[ $NetUp == "c" ]]; then
				echo -e %{F$color4}$INet%{F-}
			else
				echo ""
			fi
		else
			echo ""
		fi
	}

	# Approved
	Time() {
		TIME=$(date "+%l:%M:%S")
		echo %{F$gray}$ITime$SEP$TIME%{F-}
	}

	# Meh. Bc, cat, grep - that's a lot.
	UpTime() {
		# Read uptime, divide to convert from seconds to days.
		# Print only to 2 decimal places.
		UPTIME=$(cat /proc/uptime | awk '{print $1 / 86400}' | grep -o "[0-9]\+\.[0-9]\{0,2\}")

		echo %{F$color1}$IUpTime$SEP$UPTIME%{F-}
	}

	# Okay
	Volume() {
		# Crap I hopefully never have to work on again >>://
		# If the sound is not muted
		if [[ $(pamixer --get-mute | grep "false") ]]; then
			VOL=$(pamixer --get-volume)
			if [[ $VOL -lt 50 ]]; then
				Icon=$IVolLow
			else
				Icon=$IVolHigh
			fi

			VOL+="%"
		else
			VOL+="M"
		fi

		echo %{F$color5}$Icon$SEP$VOL%{F-}
	}

	# Okay. Maybe get rid of the click functionality just because "security" :^]
	Workspaces() {
		# How bspwm workspaces work {{{
		# for bspwm it works like this
		# you get a status output from (OUTDATED) 'bspc control --get-status'
		# (you now have to use 'bspc wm --get-status'
		# this gives you a string like this
		# 'WMDVI-D-1:oI:OII:fIII:fIV:fV:fVI:fVII:fVIII:fIX:fX:LT:mHDMI-1:ODesktop2:LT'
		# or
		# 'WmHDMI-0:oI:OII:fIII:fIV:fV:LT:MDVI-D-0:oVI:OVII:fVIII:fIX:fX:LT'
		# the letter before the workspace name represents a quality of it
		# 'o' means it has windows in it
		# 'f' means it is empty
		# 'u' means it is urgent
		# Any of these letters in capitals means you are in that workspace }}}

		# get the workspace status/workspace names and the divider between monitors
		# from the --get-status command

		# Get status, chop up into individual lines, get the lines that start with
		# 'o', 'f', 'u', 'O', 'F', 'U' or contain a number
		bstatus=$(bspc wm --get-status | tr ':' '\n' | grep "\([0-9]\)\|\(^[ofuOFU]\)")
		# Replace monitor names with '|'
		bstatus=$(echo "$bstatus" | sed "s/.*[0-9].*/|/g")
		workspace="$SEP4"
		num=1
		for i in $(echo $bstatus); do
			case $i in
				[OFU]*)
				# get workspace name
				# wsn=$(echo $i | sed 's/[OFUofu]//')
				workspace+="%{F$base05}%{A:bspc desktop -f ^$num:}$IWorkspaceFocused%{A}%{F-}$SEP4"
				let num++;;
				o*)
				workspace+="%{F$base05}%{A:bspc desktop -f ^$num:}$IWorkspaceUnfocused%{A}%{F-}$SEP4"
				let num++;;
				f*)
				workspace+="%{F$base05}%{A:bspc desktop -f ^$num:}$IWorkspaceEmpty%{A}%{F-}$SEP4"
				let num++;;
				u*)
				workspace+="%{F$base02}%{A:bspc desktop -f ^$num:}$IWorkspaceUnfocused%{A}%{F-}$SEP4"
				let num++;;
				\|)
				# if this is the first item in the list (the first monitor)
				# then we don't output it or else we get | * * * * * | * * * * *
				# instead of * * * * * | * * * * *
				if [[ num -ne 1 ]]; then
					# Divider between monitors
					workspace+="%{F$base05}$IMonitorDivider%{F-}$SEP4"
				fi;;
			esac
		done
		# Trim surrounding whitespace
		# workspace=$(echo $workspace | sed "s/^[ \t]\+//" | sed "s/[ \t]\+$//")
		echo "$workspace"
	}

	barleft="$SEP4$(UpTime)$SEP4$(CpuTemp)$SEP4$(Memory)$SEP4$(NetUp)"
	barcenter="$(Workspaces)"
	barright="$(Brightness)$SEP4$(Battery)$SEP4$(Volume)$SEP4$(Date)$SEP4$(Time)$SEP4"

	#="%{S0}%{l}$barleft%{c}$barcenter%{r}$barright
	finalbarout=""
	tmp=0
	for screen in $(echo "$Screens"); do
		finalbarout+="%{S${tmp}}%{l}$barleft%{c}$barcenter%{r}$barright"
		let tmp=$tmp+1
	done

	echo "${finalbarout}"
}



screennum=$(echo "$Screens" | wc -l)
clickablenum=$((screennum*11))
echo "click = $clickablenum" > lbarOut

if [[ $screenum -eq 1 ]]; then
	let OH=1
	let OF=-1
else
	let OH=2
	let OF=-2
fi

while true; do
	echo "$(bar)"
	sleep $refresh;
done | lemonbar -g x30 -a $clickablenum -u 2 -o 0 -f $tamzen -o -2 -f $siji10 -B "#2b303b" -F "#c0c5ce" | bash &
