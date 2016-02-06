#!/bin/bash

# Colours, Icons and Separators {{{
# Colours
. ~/coloursconf

# Icons
IUpTime=""
IUp=""
IDown=""
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

# Create temp files
mkdir -p /tmp/.lemonbarscripts
echo "false" >/tmp/.lemonbarscripts/cputnotif
echo "false" >/tmp/.lemonbarscripts/batterynotif
echo "0" >/tmp/.lemonbarscripts/netdown
echo "0" >/tmp/.lemonbarscripts/netup

# Names of all the screen outputs being used
Screens=$(xrandr | grep -o "^.* connected" | sed "s/ connected//")

bar() {

	Battery() {
		# Can be 'Full', 'Discharging', 'Unknown' or 'Charging'.
		# Unknown sometimes means charging on my laptop???
		STATUS=$(cat /sys/class/power_supply/BAT0/status)
		BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)
		stat=$IBattery0
		# If the system has a battery/is using BAT0
		if [[ BATTERY != *"No such file or directory"* ]]; then
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
		BRIGHTNESS+="%"
		echo %{F$gray}$IBrightness$SEP$BRIGHTNESS%{F-}
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

	NetworkDown() {
		LASTSAMPLE=$(cat /tmp/.lemonbarscripts/netdown)
		SAMPLE=$(cat /proc/net/dev | grep ".*:[ \t]\+[0-9]\+" | awk '{print $2}')
		Down=0
		for bytes in $(echo $SAMPLE); do
			let Down+=$bytes
		done
		let FDown=$Down
		let FDown=$FDown-$LASTSAMPLE
		# Conversion info {{{
		# convert from B to KB = /1000, from /0.05s to /s = *20
		# We want KB/s then from there we'll chop it up into MB/s. We do that instead of
		# just converting to MB/s because bash doesn't do floats so we have to simulate
		# them with strings and string manipulations
		# /1000 for KB, *20 for /s }}}
		let FDown/=20
		FStrO=$(echo $FDown)
		while [[ $(expr length $FStrO) < 4 ]]; do
			FStrO="0"$FStrO
		done
		# Get the non decimal portion of the MB/s value
		FStr=$(echo $FStrO | sed "s/[0-9]\{1,3\}$//")
		FStr+="."
		# Gets the decimal values for the MB/s value
		FStr+=$(echo $FStrO | grep -o "[0-9]\{1,3\}$")
		# Remove the last digit so that the final result is to 2 decimals
		FStr=$(echo $FStr | sed "s/[0-9]$//")
		FStr+="MB"

		echo %{F$gray}$IDown$SEP$FStr%{F-}
		# Save as "LASTSAMPLE"
		echo $Down >/tmp/.lemonbarscripts/netdown
	}

	NetworkUp() {
		LASTSAMPLE=$(cat /tmp/.lemonbarscripts/netup)
		SAMPLE=$(cat /proc/net/dev | grep ".*:[ \t]\+[0-9]\+" | awk '{print $10}')
		Up=0
		for bytes in $(echo $SAMPLE); do
			let Up+=$bytes
		done
		let FUp=$Up
		let FUp=$FUp-$LASTSAMPLE
		# Conversion info {{{
		# convert from B to KB = /1000, from /0.05s to /s = *20
		# We want KB/s then from there we'll chop it up into MB/s. We do that instead of
		# just converting to MB/s because bash doesn't do floats so we have to simulate
		# them with strings and string manipulations
		# /1000 for KB, *20 for /s }}}
		let FUp/=20
		FStrO=$(echo $FUp)
		while [[ $(expr length $FStrO) < 4 ]]; do
			FStrO="0"$FStrO
		done
		# Get the non decimal portion of the MB/s value
		FStr=$(echo $FStrO | sed "s/[0-9]\{1,3\}$//")
		FStr+="."
		# Gets the decimal values for the MB/s value
		FStr+=$(echo $FStrO | grep -o "[0-9]\{1,3\}$")
		# Remove the last digit so that the final result is to 2 decimals
		FStr=$(echo $FStr | sed "s/[0-9]$//")
		FStr+="MB"

		echo %{F$gray}$IUp$SEP$FStr%{F-}
		# Save as "LASTSAMPLE"
		echo $Up >/tmp/.lemonbarscripts/netup
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
		# VOL=$(amixer -D pulse get Master | grep Left: | grep -o "[0-9]*%" || echo "--") }}}
		VOL=50
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

	echo "%{l}$SEP2$(UpTime)$SEP2$(CpuTemp)$SEP2$(Memory)$SEP2$(NetworkUp)$SEP2$(NetworkDown)%{c}$(Workspaces)%{r}$(Brightness)$SEP2$(Battery)$SEP2$(Volume)$SEP2$(Date)$SEP2$(Time)$SEP2"
}

# Make a new bar for each monitor the system has
for screen in $(echo $Screens); do
	# Get information about the screen like its dimensions
	BarXY=$(xrandr | grep $screen | grep -o "+[0-9]\++[0-9]\+")
	ScreenWidth=$(xrandr | grep $screen | grep -o "[0-9]\+x" | sed "s/x//")
	# Final qualities of the bar. Width and X and Y
	Dimensions=$(echo "$ScreenWidth x30 $BarXY" | sed "s/ //")
	while true; do
		echo "$(bar)"
		sleep 0.05;
	done | lemonbar -g $Dimensions -a 11 -u 2 -o 1 -f "Hermit-10" -o -1 -f "FontAwesome-11" -B $bg -F $fg | bash &
done
