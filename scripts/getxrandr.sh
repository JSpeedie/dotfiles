screens=$(xrandr | grep -o "^.* connected" | sed "s/ connected//g")
# For the foreseeable future I will want monitor that is hooked up through
# DiplayPort to be my primary monitor
primary_out=$(echo "$screens" | grep -o "DP-." | awk '{print $1}')

# If there is only one monitor connected
if [[ $(echo "$screens" | wc -l) -eq 1 ]]; then
	dims=$(xrandr | grep " connected" | awk '{print $3}' | grep -o "[0-9]\+x[0-9]\+")
	echo "xrandr --output $screens --primary --mode $dims --pos 0x0 --rotate normal"
elif temp=$(echo "$screens" | grep "^${primary_out}"); then
	final_out="xrandr "

	for scr in $(echo "$screens"); do
		dims=$(xrandr | grep " connected" | grep "$scr" \
			| awk '{print $3}' | grep -o "[0-9]\+x[0-9]\+")
		final_out+="--output $scr --mode $dims "
		if temp=$(echo "$scr" | grep "^$primary_out"); then
			final_out+="--primary "
		else
			final_out+="--left-of $primary_out "
		fi
	done
fi

echo "$final_out"
