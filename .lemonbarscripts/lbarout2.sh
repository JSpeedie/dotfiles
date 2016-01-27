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
# IBat
IDate=""
ITime=""
ILock=""

IWorkspaceFocused=""
IWorkspaceUnfocused=""
IWorkspaceEmpty=""

# Separators
SEP=" "
SEP2="  "
SEP4="    "
SEP6="      "

bar() {

	CpuTemp() {
		CPUTEMP=$(conky -q -c conkybar -t '$acpitemp')
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
		# exec amixer -D pulse get Master | grep Left: | grep -o "[0-9]*%" | grep -o "[0-9]*"
		VOL=$(amixer -D pulse get Master | grep Left: | grep -o "[0-9]*%")
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

		# nly make use of 3 workspaces on this monitor
		status=$(bspc control --get-status | grep -o "^.*:LT" | cut -d':' -f2-6 | tr ':' '\n')
		workspace="$SEP4"
		for i in $(echo $status)
		do
			case $i in
			  [OFU]*)
			  wsn=$(echo $i | sed 's/[OFUofu]//')
			  # The workspace you are currently in
			  workspace+="%{F$fg}$IWorkspaceFocused%{F-}$SEP4";;
			  o*)
			  # Non-empty workspace you are not in
			  workspace+="%{F$fg}$IWorkspaceUnfocused$SEP4%{F-}";;
			  f*)
			  # Empty workspace you are not in
			  workspace+="%{F$fg}$IWorkspaceEmpty$SEP4%{F-}";;
			  u*)
                          # Urgent workspace you are not in
                          workspace+="%{F$redl}$IWorkspaceUnfocused$SEP4%{F-}";;
			esac
		done
		echo "$workspace"
	}

	echo "%{l}$SEP2$(UpTime)$SEP2$(CpuTemp)$SEP2$(Memory)\
		%{c}$(Workspaces)\
		%{r}$SEP2$(Volume)$SEP2$(Date)$SEP2$(Time)$SEP2"
}

while true; do
	echo "$(bar)"
	sleep 0.05;
done | lemonbar -g 1920x30+0+0 -u 2 -o 0 -f "Hermit-10" -o -2 -f "FontAwesome-12" -B $bg0_s -F $fg | bash &
sleep 1s
