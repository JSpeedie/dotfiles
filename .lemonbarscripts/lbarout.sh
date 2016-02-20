#!/bin/bash

# Colours, Icons and Separators {{{
# Colours
. ~/coloursconf

# Icons
IUpTime=""
INet=""
IMem=""
ICpuTemp=""
ICpuLoad=""
IVolS=""
IVolM=""
IVolL=""
IBattery0=""
IBattery1=""
IBattery2=""
IBattery3=""
IBattery4=""
IDate=""
ITime=""
ILock=""
IBrightness=""

# Workspace Icons
IWorkspaceFocused=""
IWorkspaceUnfocused=""
IWorkspaceEmpty=""
IMonitorDivider="|"

# Separators
SEP=" "
SEP2="  "
SEP4="    "
SEP6="      "
# }}}

# Other stuff
refresh=0.5

# Create temp files
# mkdir -p /tmp/.lemonbarscripts
# echo "false" >/tmp/.lemonbarscripts/cputnotif
# echo "false" >/tmp/.lemonbarscripts/batterynotif

# Names of all the screen outputs being used
Screens=$(xrandr | grep -o "^.* connected" | sed "s/ connected//")

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
			if [[ $STATUS == "Unknown" ]] || [[ $STATUS == "Charging" ]]; then
				stat=""
			else
				if [ $BATTERY -lt 20 ]; then stat=$IBattery0
				elif [ $BATTERY -lt 40 ]; then stat=$IBattery1
				elif [ $BATTERY -lt 60 ]; then stat=$IBattery2
				elif [ $BATTERY -lt 80 ]; then stat=$IBattery3
				else stat=$IBattery4; fi
			fi
			BATTERY=$(cat /sys/class/power_supply/BAT0/capacity || cat /sys/class/power_supply/BAT1/capacity) 
			BATTERY+="%"
			echo %{F$gray}$stat$SEP$BATTERY%{F-}
		else echo ""; fi
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
		CPUTEMP=$(sensors | grep "Physical id" |  grep -o "[0-9]\+\.[0-9]\+" | head -n 1)
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
		CPUTEMP+="°C"
		echo %{F$gray}$ICpuTemp$SEP$CPUTEMP%{F-}
	}
 
	# Approved
	Date() {
		DATE=$(date "+%a %d/%m")
		echo %{F$gray}$IDate$SEP$DATE%{F-}
	}

	# Approved
	Memory() {
		MEMUSED=$(free -m | awk 'NR==2 {print $3}')
		MEMUSED+="MB"
		echo %{F$gray}$IMem$SEP$MEMUSED%{F-}
	}

	# Ok
	NetUp() {	
		# Pings the default gateway. If it is successful then we are connected. Benefits
		# are that this doesn't rely on random websites being up and will always be accurate
		defGate=$(ip r | grep default | cut -d ' ' -f 3)
		NetUp=$(ping -q -w 1 -c 1 $defGate > /dev/null && echo c || echo u)
		# If some network interface is up
		if [[ $NetUp == "c" ]]; then
			echo %{F$gray}$INet%{F-}
		else
			echo ""
		fi
	}

	# Approved
	Time() {
		TIME=$(date "+%l:%M:%S")
		echo %{F$gray}$ITime$SEP$TIME%{F-}
	}

	# Approved
	UpTime() {
		UPTIME=$(uptime -p)
		Min=$(echo $UPTIME | grep -o "[0-9]\+ min" | grep -o "[0-9]\+")
		Hour=$(echo $UPTIME | grep -o "[0-9]\+ hour" | grep -o "[0-9]\+")
		Day=$(echo $UPTIME | grep -o "[0-9]\+ day" | grep -o "[0-9]\+")
		Day="$Day "
		
		out="$Day$Hour:$Min"

                echo %{F$gray}$IUpTime$SEP$out%{F-}
	}

	# Okay
	Volume() {
		# Crap I still have to work on >:/// {{{
		# OUT=$(amixer -c 0 | grep -o "Invalid card number.")
		# Card was found
		# if [[ $OUT == "" ]];
		# then
			# Check to see if card is being used
			
		# Card was not found
		# else
			
		# fi
		
		# This should maybe be changed so that it doesn't serach for Left but rather just a percent
		# exec amixer -D pulse get Master | grep Left: | grep -o "[0-9]*%" | grep -o "[0-9]*"
		# }}}
		VOL=$( (amixer get Master | grep Left: | grep -o "[0-9]\+%" | grep -o "[0-9]\+") || echo "--")
		if [[ $VOL -lt 33 ]]; then Icon=$IVolS
		elif [[ $VOL -le 66 ]]; then Icon=$IVolM
		else Icon=$IVolL; fi
		
		VOL+="%"

		echo %{F$gray}%{A:urxvt -e "alsamixer -V all &":}$Icon$SEP$VOL%{A}%{F-}
	}

	# Okay. Maybe get right of the click functionality just because security :^]
	Workspaces() {
		# How bspwm workspaces work {{{
		# for bspwm it works like this
		# you get a status output from 'bspc control --get-status'
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
		bstatus=$(bspc control --get-status | sed "s/LT/|/" | sed "s/|$//" | tr ':' '\n')
		# Get rid of the monitor names and other information that is not needed
		bstatus=$(echo $bstatus | grep "\(^[OFUofu]\{1,\}.*$\)\||")
		workspace="$SEP4"
		num=1
		for i in $(echo $bstatus); do
			case $i in
			  [OFU]*)
			  # get workspace name
			  wsn=$(echo $i | sed 's/[OFUofu]//')
			  workspace+="%{F$fg}%{A:bspc desktop -f ^$num:}$IWorkspaceFocused%{A}%{F-}$SEP4"
			  let num++;;
			  o*)
			  workspace+="%{F$fg}%{A:bspc desktop -f ^$num:}$IWorkspaceUnfocused%{A}%{F-}$SEP4"
			  let num++;;
			  f*)
			  workspace+="%{F$fg}%{A:bspc desktop -f ^$num:}$IWorkspaceEmpty%{A}%{F-}$SEP4"
			  let num++;;
			  u*)
                          workspace+="%{F$red}%{A:bspc desktop -f ^$num:}$IWorkspaceUnfocused%{A}%{F-}$SEP4"
			  let num++;;
			  \|)
                          # Divider between monitors
                          workspace+="%{F$fg}$IMonitorDivider%{F-}$SEP4";;
			esac
		done
		# Trim surrounding whitespace
		# workspace=$(echo $workspace | sed "s/^[ \t]\+//" | sed "s/[ \t]\+$//")
		echo "$workspace"
	}

	barleft="$SEP2$(UpTime)$SEP2$(CpuTemp)$SEP2$(Memory)$SEP2$(NetUp)"
	barcenter="$(Workspaces)"
	barright="$(Brightness)$SEP2$(Battery)$SEP2$(Volume)$SEP2$(Date)$SEP2$(Time)$SEP2"
	
	# ="%{S0}%{l}$barleft%{c}$barcenter%{r}$barright
	# finalbarout=""
	# tmp=0
	# for screen in $Screens; do
		# finalbarout="${finalbarout}%{S${tmp}}%{l}$barleft%{c}$barcenter%{r}$barright"
		# tmp=$tmp+1
	# done

	echo "%{S0}%{l}$barleft%{c}$barcenter%{r}$barright%{S1}%{l}$barleft%{c}$barcenter%{r}$barright"
	# echo $finalbarout
}


screennum=$(echo $Screens | wc -l)
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
done | lemonbar -g x30 -a 22 -u 2 -o $OH -f "Hermit-10" -o $OF -f "FontAwesome-11" -B $bg -F $fg | bash &
