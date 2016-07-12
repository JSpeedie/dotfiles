# Get song name by prompting user with rofi
song=$(mpc list title | rofi -dmenu -m -2 -lines 40)
# Get file path of song
file=$(mpc search title "$song" | head -n 1)

echo "$song" > ~/mpdOut;
echo "$file" >> ~/mpdOut

# Insert song at next spot in playlist
mpc insert "$file"
# Go to next song
mpc next
# Play next song (if you're at the end of the playlist, mpc next won't play
# the next song. Think of this as an option select.
# mpc play
