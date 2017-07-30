# If wucm is already running
if pidof wucm >/dev/null; then
	killall wucm
else
	wucm
fi
