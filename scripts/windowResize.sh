# If wrc is already running
if pidof wrc >/dev/null; then
	echo "";
else
	wrc
fi
