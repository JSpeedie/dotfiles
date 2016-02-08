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

# Separators
SEP=" "
SEP2="  "
SEP4="    "
SEP6="      "
# }}}

# Other stuff
refresh=0.25
refreshflip=4

# Create temp files
mkdir -p /tmp/.lemonbarscripts
echo "false" >/tmp/.lemonbarscripts/cputnotif
echo "false" >/tmp/.lemonbarscripts/batterynotif

# Names of all the screen outputs being used
Screens=$(xrandr | grep -o "^.* connected" | sed "s/ connected//")

bar() {

	Battery() {
		# If this system has a battery (needs work)
		if [[ -e /sys/class/power_supply/BAT0/status ]] && [[ -e /sys/class/power_supply/BAT0/capacity ]]; then
			# Can be 'Full', 'Discharging', 'Unknown' or 'Charging'.
			# Unknown sometimes means charging on my laptop???
			STATUS=$(cat /sys/class/power_supply/BAT0/status)
			BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)
			stat=$IBattery0
			# If the system has a battery/is using BAT0
			# Notifications {{{
			# If battery is less than 15 (low imo) send a notification
			if [[ $BATTERY -lt 15 ]]; then
				NOTIF=$(cat /tmp/.lemonbarscripts/batterynotif)
				# If the user has not been notified about the battery being low
				if [[ $NOTIF == "false" ]]; then
					# Sends a notification to their notification client. I use dunst
					notify-send "Low battery" -u critical
					# change the text in the file to say true so we know in the
					# future to not notify them again too quickly (to avoid spam)
					echo "true" >/tmp/.lemonbarscripts/batterynotif
				fi
			# cpu temps are low so re-allow sending the notification
			elif [[ $BATTERY -gt 15 ]]; then
				echo "false" >/tmp/.lemonbarscripts/batterynotif
			fi
			# }}}
			if [ $BATTERY -lt 20 ]; then stat=$IBattery0
			elif [ $BATTERY -lt 40 ]; then stat=$IBattery1
			elif [ $BATTERY -lt 60 ]; then stat=$IBattery2
			elif [ $BATTERY -lt 80 ]; then stat=$IBattery3
			else stat=$IBattery4; fi

			if [[ $STATUS == "Unknown" ]] || [[ $STATUS == "Charging" ]]; then
				stat=""
			fi
			BATTERY+="%"
			echo %{F$gray}$stat$SEP$BATTERY%{F-}
		else echo ""; fi
	} 

	Brightness() {
		BRIGHTNESS=$(xbacklight -get | grep -o "[0-9]\+\.[0-9]\?")
		if [[ $BRIGHTNESS != "" ]]; then
			BRIGHTNESS+="%"
			echo %{F$gray}$IBrightness$SEP$BRIGHTNESS%{F-}
		else
			echo ""
		fi
	}

	CpuTemp() {
		# Get the temps of all the cores and calculate the average temp
		CPUTEMPS=$(sensors | grep "Core" | sed "s/(.*)//" | grep -o "[0-9]\+\." | sed "s/\.//")
		CPUTEMP=0
		cores=0
		for temp in $CPUTEMPS; do
			let CPUTEMP+=$temp
			let cores+=1
		done
		if [[ cores -gt 0 ]]; then
			let CPUTEMP=$CPUTEMP/$cores
			# Notifications {{{
			if [[ $CPUTEMP -gt 65 ]]; then
				NOTIF=$(cat /tmp/.lemonbarscripts/cputnotif)
				# If the user has not been notified about the cpu temp being high
				if [[ $NOTIF != "true" ]]; then
					# Sends a notification to their notification client. I use dunst
					notify-send "High cpu temps"
					# change the text in the file to say true so we know in the
					# future to not notify them again too quickly (to avoid spam)
					echo "true" >/tmp/.lemonbarscripts/cputnotif
				fi
			# cpu temps are low so reallow sending the notification
			else echo "false" >/tmp/.lemonbarscripts/cputnotif; fi	
			# }}}

			CPUTEMP+="°C"
		# Couldn't find any cpu cores so output this
		else CPUTEMP="--"; fi

		echo %{F$gray}$ICpuTemp$SEP$CPUTEMP%{F-}
	}
 
	Date() {
		DATE=$(date "+%a %d/%m")
		echo %{F$gray}$IDate$SEP$DATE%{F-}
	}

	Memory() {
		MEMUSED=$(free -m | awk 'NR==2 {print $3}')
		MEMUSED+="MB"
		echo %{F$gray}$IMem$SEP$MEMUSED%{F-}
	}

	NetUp() {	
		Down=$(ifstat | grep enp5s0 | awk '{print $6}')
		NetUp=$(ip a | grep -v "lo" | grep "<" | grep "UP")
		# If some network interface is up
		if [[ NetUp != "" ]]; then
			echo %{F$gray}$INet%{F-}
		else
			echo ""
		fi
	}

	Time() {
		TIME=$(date "+%l:%M:%S")
		echo %{F$gray}$ITime$SEP$TIME%{F-}
	}

	UpTime() {
		UPTIME=$(uptime | grep -o "up[ \t]\+[0-9]\+\(:[0-9]\+\)*" | sed "s/up //")
                echo %{F$gray}$IUpTime$SEP$UPTIME%{F-}
	}

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
		VOL=$(amixer get Master | grep Left: | grep -o "[0-9]*%" || echo "--")
		# }}}
		echo %{F$gray}%{A:urxvt -e "alsamixer -V all &":}$IVolS$SEP$VOL%{A}%{F-}
	}

	Workspaces() {
		# How bspwm workspaces work {{{
		# for bspwm it works like this
		# you get a status output from 'bspc control --get-status'
		# this gives you a string like this
		# 'WMDVI-D-1:oI:OII:fIII:fIV:fV:fVI:fVII:fVIII:fIX:fX:LT:mHDMI-1:ODesktop2:LT'
		# the letter before the workspace name represents a quality of it
		# 'o' means it has windows in it
		# 'f' means it is empty
		# 'u' means it is urgent
		# Any of these letters in capitals means you are in that workspace }}}

		# get the workspace status/workspace name lines from the --get-status command
		bstatus=$(bspc control --get-status | tr ':' '\n' | grep "^[OFUofu]\{1,\}.*$")		
		workspace="$SEP4"
		num=1
		for i in $(echo $bstatus); do
			case $i in
			  [OFU]*)
			  # get workspace name
			  wsn=$(echo $i | sed 's/[OFUofu]//')
			  # The workspace you are currently in
			  workspace+="%{F$fg}%{A:bspc desktop -f ^$num:}$IWorkspaceFocused%{A}%{F-}$SEP4";;
			  o*)
			  # Non-empty workspace you are not in
			  workspace+="%{F$fg}%{A:bspc desktop -f ^$num:}$IWorkspaceUnfocused%{A}%{F-}$SEP4";;
			  f*)
			  # Empty workspace you are not in
			  workspace+="%{F$fg}%{A:bspc desktop -f ^$num:}$IWorkspaceEmpty%{A}%{F-}$SEP4";;
			  u*)
                          # Urgent workspace you are not in
                          workspace+="%{F$red}%{A:bspc desktop -f ^$num:}$IWorkspaceUnfocused%{A}%{F-}$SEP4";;
			esac
			let num++
		done
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

# Get information about the screen like its dimensions
# BarXY=$(xrandr | grep $screen | grep -o "+[0-9]\++[0-9]\+")
# ScreenWidth=$(xrandr | grep $screen | grep -o "[0-9]\+x" | sed "s/x//")
# Final qualities of the bar. Width and X and Y
# Dimensions=$(echo "${ScreenWidth}x30${BarXY}")
while true; do
	echo "$(bar)"
	sleep $refresh;
done | lemonbar -g x30 -a 22 -u 2 -o 1 -f "Hermit-10" -o -1 -f "FontAwesome-11" -B $bg -F $fg | bash &
