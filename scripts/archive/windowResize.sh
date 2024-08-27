# If wucr is already running
if pidof wucr >/dev/null; then
	killall wucr
else
	wucr
fi
