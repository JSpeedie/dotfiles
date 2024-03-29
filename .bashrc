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
alias conuni='sudo wpa_supplicant -c ~/wpa_supplicant.conf -i wlp2s0 -D nl80211 -B && sudo dhcpcd wlp2s0'
alias ls='ls --color=auto'
alias dtest='sh ~/scripts/difftest.sh'
alias lock='sh ~/scripts/lock.sh'
alias updatedot='sh ~/scripts/updatedir.sh ~/ ~/dotfilesGit/ ~/scripts/updatedirgit.sh'
alias updatepelagic='sh ~/scripts/updatedir.sh ~/.vim/colors/ ~/pelagicGit/ ~/scripts/updatedirpelagic.sh'
alias barscr='ffmpeg -video_size 1220x40 -framerate 60 -f x11grab -i :0.0+2590,0 -vframes 1 output.png'
# Record Desktop (full screen)
alias rd='ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i :1.0+0,0 output.mp4'
alias rdl='ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i :0.0+0,0 -c:v libx264 -qp 0 -preset ultrafast output.mkv'
# Record Desktop Medium (1/2 of the screen)
alias rdm='ffmpeg -video_size 960x540 -framerate 60 -f x11grab -i :0.0+480,270 output.mp4'
# Record Desktop Small (1/3 of the screen)
alias rds='ffmpeg -video_size 640x360 -framerate 60 -f x11grab -i :0.0+640,360 output.mp4'
alias rwfs='wtp 0 0 608 328 $(cfw)'
# Record Desktop Very Small (1/4 of the screen)
alias rdvs='ffmpeg -video_size 480x270 -framerate 60 -f x11grab -i :0.0+720,405 output.mp4'
alias rwfvs='wtp 0 0 456 246 $(cfw)'
# Record Desktop Ultra Small (1/6 of the screen)
alias rdus='ffmpeg -video_size 320x180 -framerate 60 -f x11grab -i :0.0+800,450 output.mp4'
alias rwfus='wtp 0 0 304 164 $(cfw)'
# For when you gotta let em know
alias fuckyou='yes "$(echo "fuck you" | figlet -f slant)" | lolcat'
alias ctest='sh ~/scripts/colortest.sh'
alias bonsai='sh ~/scripts/bonsai.sh 2 6'
alias slippi='./Slippi-Launcher-1.4.2-x86_64.AppImage'
alias elgato='sudo ~/elgato-gchd/build/src/gchd -i component'

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

upt () {
	awk '{printf "%.2f\n", $1 / 86400}' /proc/uptime
}

##############################
#       Dynamic Prompt       #
##############################

reset=$(tput sgr0)
# colour directory and colour actual directory
c_d=$(tput setaf 14; tput setab 0)
success=$(tput setaf 7; tput setab 0)
fail=$(tput setaf 1; tput setab 0)

cur_dir() {
	printf "$(pwd | sed -e "s/\/home\/$USER/~/" | tr "\/" "\n" | tail -n 1)"
}

prompt () {
	result='$(if [[ $? -ne 0 ]]; then \
				printf "\001${c_d}\002$(cur_dir)\001${reset}\002 \001${fail}\002_\001${reset}\002 "; \
			else \
				printf "\001${c_d}\002$(cur_dir)\001${reset}\002 \001${success}\002_\001${reset}\002 "; \
			fi)'
	printf "${result}"
}

# jpgtopdf 42389.jpg receipt.pdf
jpgtopdf () {
	convert $1 -auto-orient $2
}

mdtopdf () {
	pandoc $1 --pdf-engine=lualatex -o $2
}

textopdf () {
	# pdflatex $1
	# Older method
	pandoc -f latex $1 --pdf-engine=lualatex -o $2
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
	convert kantpoliticalwritings2ndedcover.jpg kantpoliticalwritings2ndedcover.pdf

	# Unused - possibly unnecessary
	# pdfjam --paper 'a4paper' --scale 0.5 --offset '0cm -0cm' kantpoliticalwritings2ndedcover.pdf

	# Make a copy of the first page of the pdf for us to stamp the cover image onto
	pdftk Kant_\ Political\ Writings.pdf cat 1 output firstpage.pdf

	# Stamp the cover image onto the duplicated first page
	pdftk firstpage.pdf stamp kantpoliticalwritings2ndedcover.pdf output stampedfirstpage.pdf

	# Prepend the stamped first page to the original document
	pdftk stampedfirstpage.pdf Kant_\ Political\ Writings.pdf cat output combined.pdf
}

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

trim () {
	ffmpeg -i $1 -ss $2 -to $3 -c copy -async 1 $4
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
