#!/bin/bash

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

IWorkspaceFocused=""
IWorkspaceUnfocused=""
IWorkspaceEmpty=""

# Get information about the system/setup like screen dimensions and number of screens
# ScreenWidth script may have to be changed in the future because it won't work
# on a multi monitor setup with different resolution monitors
ScreenWidth=$(xrandr -q | grep "^.* connected" | grep -o "[0-9]\{1,\}x" | sed "s/x//")
Dimensions=$(echo "$ScreenWidth x30+0+0" | sed "s/ //")
ScreensTemp=$(xrandr | grep -o "^.* connected" | sed "s/ connected//")
NumScreens=0
for i in $(echo $ScreensTemp)
do
	let NumScreens++
done

# Separators
SEP=" "
SEP2="  "
SEP4="    "
SEP6="      "

# Create temp files
mkdir -p /tmp/.lemonbarscripts
echo "false" >/tmp/.lemonbarscripts/cputnotif
echo "false" >/tmp/.lemonbarscripts/batterynotif

bar() {
	Battery() {
		BATTERY=$(conky -q -c conkybar -t '$battery_percent')
		if [ $BATTERY -lt 20 ];
		then
			# If battery is less than 15 (low imo) send a notification
			if [[ $BATTERY -lt 15 ]];
				then
				NOTIF=$(cat /tmp/.lemonbarscripts/batterynotif)
				# If the user has not been notified about the battery being low
				if [[ $NOTIF != "true" ]];
				then
					# Sends a notification to their notification client. I use dunst
					notify-send "Low battery" -u critical
					# change the text in the file to say true so we know in the
					# future to not notify them again too quickly (to avoid spam)
					echo "true" >/tmp/.lemonbarscripts/batterynotif
				fi
			elif [[ $BATTERY -gt 15 ]];
			then
				# cpu temps are low so reallow sending the notification
				echo "false" >/tmp/.lemonbarscripts/batterynotif
			fi
			echo %{F$yellow}$IBattery0$SEP$BATTERY%{F-}
		elif [ $BATTERY -lt 40 ];
		then
			echo %{F$yellow}$IBattery1$SEP$BATTERY%{F-}
		elif [ $BATTERY -lt 60 ];
		then
			echo %{F$yellow}$IBattery2$SEP$BATTERY%{F-}
		elif [ $BATTERY -lt 80 ];
		then
			echo %{F$yellow}$IBattery3$SEP$BATTERY%{F-}
		else
			echo %{F$yellow}$IBattery4$SEP$BATTERY%{F-}
		fi
	} 

	Brightness() {
		BRIGHTNESS=$(xbacklight -get | grep -o "[0-9]\+\.[0-9]\?")
		echo %{F$yellow}$IBrightness$SEP$BRIGHTNESS%{F-}
	}
	
	CpuTemp() {
		CPUTEMP=$(conky -q -c conkybar -t '$acpitemp')
		if [[ $CPUTEMP -gt 65 ]];
		then
			NOTIF=$(cat /tmp/.lemonbarscripts/cputnotif)
			# If the user has not been notified about the cpu temp being high
			if [[ $NOTIF != "true" ]];
			then
				# Sends a notification to their notification client. I use dunst
				notify-send "High cpu temps"
				# change the text in the file to say true so we know in the
				# future to not notify them again too quickly (to avoid spam)
				echo "true" >/tmp/.lemonbarscripts/cputnotif
			fi
		elif [[ $CPUTEMP -lt 65 ]];
		then
			# cpu temps are low so reallow sending the notification
			echo "false" >/tmp/.lemonbarscripts/cputnotif
		fi
		
		CPUTEMP+="°C"
		echo %{F$orange}$ICpuTemp$SEP$CPUTEMP%{F-}
	}
	 
	Date() {
		DATE=$(date "+%a %d/%m")
		echo %{F$orange}$IDate$SEP$DATE%{F-}
	}

	Memory() {
		MEMUSED=$(free -m | awk 'NR==2 {print $3}')
		MEMUSED+="MB"
		echo %{F$orangel}$IMem$SEP$MEMUSED%{F-}
	}

	Time() {
		TIME=$(date "+%l:%M:%S")
		echo %{F$redl}$ITime$SEP$TIME%{F-}
	}

	UpTime() {
		UPTIME=$(conky -q -c conkybar -t '$uptime')
                echo %{F$redl}$IUpTime$SEP$UPTIME%{F-}
	}

	Volume() {
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
		# VOL=$(amixer -D pulse get Master | grep Left: | grep -o "[0-9]*%" || echo "--")
		VOL=50
		echo %{F$orangel}%{A:urxvt -e "alsamixer -V all &":}$IVolS$SEP$VOL%{A}%{F-}
	}
	
	Workspaces() {
		# for bspwm it works like this
		# you get a status output from 'bspc control --get-status'
		# this gives you a string like this
		# 'WMDVI-D-1:oI:OII:fIII:fIV:fV:fVI:fVII:fVIII:fIX:fX:LT:mHDMI-1:ODesktop2:LT'
		# the letter before the workspace name represents a quality of it
		# 'o' means it has windows in it, but you are not in it
		# 'O' means it has windows and you are in it
		# 'f' means it is empty
		# 'F' means it is empty and you are in it
		
		if [[ $NumScreens > 2 ]];
		then
			# Only make use of 5 workspaces on this monitor
			status=$(bspc control --get-status | grep -o "LT:.*:LT" | cut -d':' -f3-7 | tr ':' '\n')
		else
			# Make use of all 10 workspaces on this screen
			status=$(bspc control --get-status | grep -o "^.*:LT" | cut -d':' -f2-11 | tr ':' '\n')
		fi
		workspace="$SEP4"
		num=1
		for i in $(echo $status)
		do
			case $i in
			  [OFU]*)
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
                          workspace+="%{F$redl}%{A:bspc desktop -f ^$num:}$IWorkspaceUnfocused%{A}%{F-}$SEP4";;
			esac
			let num++
		done
		echo "$workspace"
	}

	echo "%{l}$SEP2$(UpTime)$SEP2$(CpuTemp)$SEP2$(Memory)$SEP2$(Brightness)\
		%{c}$(Workspaces)\
		%{r}$SEP2$(Battery)$SEP2$(Volume)$SEP2$(Date)$SEP2$(Time)$SEP2"
}

while true; do
	echo "$(bar)"
	sleep 0.01;
done | lemonbar -g $Dimensions -a 11 -u 2 -o 0 -f "Hermit-10" -o -2 -f "FontAwesome-12" -B $bg0_s -F $fg | bash &
sleep 1s
