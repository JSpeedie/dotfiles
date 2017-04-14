# If wmc is already running
if pidof wmc >/dev/null; then
	echo "";
else
	wmc
fi
