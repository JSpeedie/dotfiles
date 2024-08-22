#
# ~/.bashrc
#

export EDITOR=vim
export VISUAL="$EDITOR"
export _JAVA_AWT_WM_NONREPARENTING=1
export ANDROID_HOME=/opt/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-9-openjdk/
export PATH=/usr/lib/jvm/java-9-openjdk/bin/:$PATH

# env XDG_CURRENT_DESKTOP=GNOME gnome-control-center
# sudo usermod -a -G vboxusers,vboxsf,wheel [username_here]

##############################
#          Aliases           #
##############################

# If the system has neovim, use that, otherwise use regular vim
if type nvim > /dev/null 2>&1; then
	alias vim="nvim"
	alias vimdiff='nvim -d'
	export EDITOR=nvim
	export VISUAL="$EDITOR"
fi
alias organizerawsandjpgs='bash ~/organizerawsandjpgs.sh'
alias ls='ls --color=auto'
alias lock='sh ~/scripts/lock.sh'
alias updatedot='sh ~/scripts/updatedir.sh ~/ ~/dotfilesGit/ ~/scripts/updatedirgit.sh'
# Record Desktop (full screen)
alias rd='ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i :1.0+0,0 output.mp4'
alias rdl='ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i :0.0+0,0 -c:v libx264 -qp 0 -preset ultrafast output.mkv'
# For when you gotta let em know
alias fuckyou='yes "$(echo "fuck you" | figlet -f slant)" | lolcat'
alias slippi='./Slippi-Launcher-1.4.2-x86_64.AppImage'
alias elgato='sudo ~/elgato-gchd/build/src/gchd -i component'
alias get_idf='. $HOME/esp/esp-idf/export.sh'

##############################
#    Colour for man pages    #
##############################

export LESS_TERMCAP_me=$(tput sgr0) # Normal
export LESS_TERMCAP_se=$(tput sgr0) # Normal
export LESS_TERMCAP_ue=$(tput sgr0) # Normal
# Section titles in man pages
export LESS_TERMCAP_md=$(tput setaf 1) # Dark gray (8)
export LESS_TERMCAP_mb=$(tput setaf 4) # Blue (4)
# Variables amongst other things in man pages
export LESS_TERMCAP_us=$(tput setaf 3) # Blue
# "Status bar" of less
export LESS_TERMCAP_so=$(tput setab 7; tput setaf 0) # Light gray (fg)

##############################
#       Dynamic Prompt       #
##############################

reset=$(tput sgr0)
# 'c_d' = invokes the foreground and background colour of the directory
c_d=$(tput setaf 7; tput setab 0; tput bold)
success=$(tput setaf 0; tput setab 2)
fail=$(tput setaf 0; tput setab 1)

# Helper function for the 'prompt()' function
cur_dir() {
	printf "$(pwd | sed -e "s/\/home\/$USER/~/" | tr "\/" "\n" | tail -n 1)"
}

prompt () {
	result='$(if [[ $? -ne 0 ]]; then \
				printf "\001${c_d}\002$(cur_dir) \001${reset}\002\001${fail}\002$\001${reset}\002 "; \
			else \
				printf "\001${c_d}\002$(cur_dir) \001${reset}\002\001${success}\002$\001${reset}\002 "; \
			fi)'
	printf "${result}"
}

upt () {
	awk '{printf "%.2f\n", $1 / 86400}' /proc/uptime
}

# jpgtopdf 42389.jpg receipt.pdf
jpgtopdf () {
	convert $1 -auto-orient $2
}

mdtopdf () {
	pandoc $1 --pdf-engine=lualatex -o $2
}

textopdf () {
	pdflatex $1
	# Older method
	#pandoc -f latex $1 --pdf-engine=lualatex -o $2
}

# concatenate pdf $1 and pdf $2 into output pdf $3.
# You can have more inputs which could take the form:
#	pdftk $1 $2 $3 cat output $4
concatenatepdfs () {
	pdftk $1 $2 cat output $3
}

# Converts the video to be 480 by 320 at 30fps. convert then optimizes
# the gif to save space.
# Expects: $ convmp4gif [file ending it ".mp4"] [file ending it ".gif"] [min scene change detection score]
# Example: High accuracy, low compression:
#          $ convmp4gif cfw.mp4 cfw.gif 0.00001
#          Low accuracy, high compression:
#          $ convmp4gif wtsr.mp4 wtsr.gif 0.001
#
# For comparisons, I used the following values for my wmcontrib gifs:
#     0.0001, 0.0005, 0.0006 for wtsr, wrsr, and cfw. For things
# involving typing or any somewhat-small scene changes, I recommend 0.00001.
convmp4gif () {
	echo ${1} ${2};
	ffmpeg -i $1 -vf "scale=480:320,select=gt(scene\,${3})" -r 30 .temp_${2} && \
	convert .temp_${2} -coalesce -layers OptimizeFrame ${2}
	rm .temp_${2}
}

# Add a cover image (i.e. prepend a page which is just the first image) to a pdf
# TODO: turn into a function - this is just a reference at the moment
pdfaddcoverpage () {
	# If you want to take the cover photo from an Amazon page, hover over the image
	# right click, inspect element, then hover over the image, and move your
	# mouse from image to the inspect console without any gap that would close
	# the detailed-image window. Then scroll to the bottom or search for the
	# "zoomWindow" div, and in there, the "detailImg" img
	convert cover.jpg cover.pdf

	# preprend the cover page to the pdf
	pdftk cover.pdf Kant_\ Political\ Writings.pdf cat output combined.pdf

}

# Update meta (page numbering + bookmarks)
pdfupdatemeta () {
	pdftk kantpoliticalwritings.pdf dump_data > meta.txt
	cp meta.txt oldmeta.txt
	# Make the changes to the meta data. If you added a cover image, you will
	# need to increase all the "PageLabelNewIndex: 14"'s by 1
	vim meta.txt
	pdftk kantpoliticalwritings.pdf update_info_utf8 meta.txt output combinedwithmetadata.pdf
}

# Split pages of pdf that contain 2 pages of the text into multiple pages in the pdf
# TODO: turn into a function - this is just a reference at the moment
#pdfsplitcombinedpages () {
	# Start gscan2pdf and open the pdf you want to work on
	# Shift select all the pages you want to split in the left toolbar
	# Click "Tools" in the menu bar (the list on the top left of the window)
	# Select "Clean Up"
	# Set Layout to "Double", and # Output pages to 2. Turn off deskew, Check "No border scan", "No mask scan", no black filter", etc. etc. Turn off all the filter
	# Ignore the unpaper errors, wait for it to finish, and you're done!
	# Click "File" in the menu bar, for Page Range, select "All", and save the file as the output file and you're done!
#}

# Taken from http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html
# Fantastic gif quality, smaller sizes without even using convert.
# Way faster since it doesn't use convert... This function is fiiire

# Takes the same arguments as the above function
# Expects: $ convmp4gif [file ending it ".mp4"] [file ending it ".gif"]
# Example: High accuracy, low compression -> enter 30, 480:320, 0.00001, 256)
#          Low accuracy, high compression -> enter 30, 480:320, 0.001, 256)
highconvmp4gif () {
	def_fps="30"
	height=$(ffprobe -v quiet -print_format json -show_streams output.mp4 | grep "\"height" | grep -o "[0-9]\+")
	width=$(ffprobe -v quiet -print_format json -show_streams output.mp4 | grep "\"width" | grep -o "[0-9]\+")
	def_scale="${width}:${height}"
	def_detect="0.0001"
	def_colours="256"

	palette="/tmp/palette.png"

	printf "Frames per Second (default=${def_fps})? "
	read -a fps
	if [[ $fps == "" ]]; then
		fps=$def_fps
	fi
	printf "Scale (default=${def_scale})? "
	read -a scale
	if [[ $scale == "" ]]; then
		scale=$def_scale
	fi
	printf "Minimum Scene Change Detection Score (default=${def_detect})? "
	read -a detect
	if [[ $detect == "" ]]; then
		detect=$def_detect
	fi
	printf "Number of colours in generated palette (default=${def_colours})? "
	read -a colours
	if [[ $colours == "" ]]; then
		colours=$def_colours
	fi

	filters="fps=${fps},scale=${scale}:flags=lanczos,select=gt(scene\,${detect})"
	ffmpeg -i $1 -vf "$filters,palettegen=${colours}" -y $palette
	printf "\n\nPress any key when satisfied with the palette... "
	read
	ffmpeg -i $1 -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y ${2}
}

# Used for deinterlacing recorded Melee footage. Quite possibly not the best
# way to do it, but works quickly and well enough.
#
# Expects: $ convdeintmov [interlaced video file] [output file name]
# Example: $ convdeintmov Recording-01.ts Output.mov
convdeintmov () {
	ffmpeg -i $1 -vf yadif=1 -c:v prores $2
}

# Used for deinterlacing recorded Melee footage. Quite possibly not the best
# way to do it, but works quickly and well enough.
#
# Expects: $ convdeintmp4 [interlaced video file] [output file name]
# Example: $ convdeintmp4 Recording-01.ts Output.mp4
convdeintmp4 () {
	ffmpeg -i $1 -vf yadif=1 $2
}

xfd-siji() {
	font='-wuncon-siji-medium-r-normal--17-120-100-100-c-80-iso10646-1'
	xfd -fn $font 2>&1 >/dev/null &
}

ffmpeg-trim () {
	# Trims the video from the 47th second to the 57th second
	ffmpeg -i in.mov -ss 00:00:47 -to 00:00:57 -async 1 out.mov
}

ffmpeg-crop () {
	ffmpeg -i in.mp4 -vf "crop=out_w:out_h:x:y" out.mp4
}

ffmpeg-resize () {
	# Resize so the height is out_h, and the width maintains the aspect ratio
	ffmpeg -i in.mp4 -vf scale="trunc(oh*a/2)*2:out_h" out.mp4
	# Resize so the width is out_w, and the height maintains the aspect ratio
	ffmpeg -i in.mp4 -vf scale="out_w:trunc(ow/a/2)*2" out.mp4
}

ffmpeg-remove-audio () {
	# The -an flag removes audio from the video
	ffmpeg -i in.mp4 -c copy -an out.mp4
}

PS1=$(prompt)
PS2='> '
export PS1 PS2

# Attempt at tty base16-dark-ocean theming
# if [ "$TERM" = "linux" ]; then
#     printf '
# \033]P2b303b \033]Pbf616a \033]Pa3be8c \033]Pebcb8b
# \033]P8fa1b3 \033]Pb48ead \033]P96b5b4 \033]Pc0c5ce
# \033]P65737e \033]Pbf616a \033]Pa3be8c \033]Pebcb8b
# \033]P8fa1b3 \033]Pb48ead \033]P96b5b4 \033]Peff1f5
# '
#     clear
# fi
. "$HOME/.cargo/env"
