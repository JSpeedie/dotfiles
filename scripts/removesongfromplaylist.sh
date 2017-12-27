MAX_LINES=40;

line_count=$(mpc playlist | wc -l)
if [[ line_count -gt $MAX_LINES ]]; then
	line_count=$MAX_LINES;
fi
# Present user with list of songs in the current playlist
# rofi flags explanation:
#	1. -dmenu, allows for combination with STDOUT
#	2. -format d, instead of returning selected string, rofi now returns
#	       the index of the selected string + 1.
#	3. -m, TODO
#	4. -2, makes rofi appear above the currently focused window
#	5. -i, makes the search case INsensitive
#	6. -matching fuzzy, makes the search a fuzzy find
#	7. -lines $line_count, sets the maximum number of lines to be shown
song_index=$(mpc playlist | rofi -dmenu -format d -m -2 -i -matching fuzzy -lines $line_count)
# If the user didn't exit rofi,
# mpc searches for a song with matching criteria and plays it
if [[ $? -eq 0 ]]; then
	mpc del $song_index
fi
