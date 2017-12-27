MAX_LINES=40;

line_count=$(mpc list title | wc -l)
if [[ line_count -gt $MAX_LINES ]]; then
	line_count=$MAX_LINES;
fi
# Get song name by prompting user with rofi
# rofi flags explanation:
#	1. -dmenu, allows for combination with STDOUT
#	2. -m, TODO
#	3. -2, makes rofi appear above the currently focused window
#	4. -i, makes the search case INsensitive
#	5. -matching fuzzy, makes the search a fuzzy find
#	6. -lines $line_count, sets the maximum number of lines to be shown
song=$(mpc list title | rofi -dmenu -m -2 -i -matching fuzzy -lines $line_count)
# If the user didn't exit rofi,
# Get file path of song
if [[ $? -eq 0 ]]; then
	file=$(mpc search title "$song" | head -n 1)
	echo "$song" > ~/mpdOut;
	echo "$file" >> ~/mpdOut

	# Insert song at next spot in playlist
	mpc --wait insert "$file"
	# Go to next song
	mpc --wait next
	# Play next song (if you're at the end of the playlist, mpc next won't play
	# the next song. Think of this as an option select.
	mpc play
fi
