#
# ~/.bashrc
#

export VISUAL=vim
export EDITOR="$VISUAL"
export _JAVA_AWT_WM_NONREPARENTING=1
export ANDROID_HOME=/opt/android-sdk

##############################
#          Aliases           #
##############################

alias conuni='sudo wpa_supplicant -c ~/wpa_supplicant.conf -i wlp2s0 -D nl80211 -B && sudo dhcpcd wlp2s0'
alias ls='ls --color=auto'
alias dtest='sh ~/scripts/difftest.sh'
alias lock='sh ~/scripts/lock.sh'
alias updatedot='sh ~/scripts/updatedir.sh ~/ ~/dotfilesGit/ ~/scripts/updatedirgit.sh'
alias convertmp4togif='ffmpeg -i output.mp4 -pix_fmt rgb24 -s 640x480 -r 10 output.gif'
alias recorddesktop='ffmpeg -video_size 1920x1080 -framerate 60 -f x11grab -i :0.0+0,0 output.mp4'
alias howconv='echo "convert -delay <ticks>x<ticks-per-second> -loop 0 out*gif <output-gif-file>"'
alias ctest='sh ~/scripts/colortest.sh'

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
#    Base16 shell colours    #
##############################

BASE16_SHELL="$HOME/.config/base16-shell/base16-ocean.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL


##############################
#       Dynamic Prompt       #
##############################

dir_colour=$(tput setaf 15)
succeed=$(tput setaf 8)
fail=$(tput setaf 1)
reset=$(tput sgr0)

directory() {
	printf "$(pwd | sed -e "s/\/home\/$USER/~/" | tr "\/" "\n" | tail -n 1)"
}

prompt () {
	result='$(if [[ $? -ne 0 ]]; then \
				printf "\001${dir_colour}\002$(directory)\001${fail}\002 • \001${reset}\002"; \
			else \
				printf "\001${dir_colour}\002$(directory)\001${succeed}\002 • \001${reset}\002"; \
			fi)'
	printf "${result}"
}

mdtopdf () {
	pandoc $1 --latex-engine=lualatex -o $2
}

PS1=$(prompt)
PS2='> '
export PS1 PS2

# Attempt at tty base16-dark-ocean theming
if [ "$TERM" = "linux" ]; then
    printf '
\033]P2b303b \033]Pbf616a \033]Pa3be8c \033]Pebcb8b
\033]P8fa1b3 \033]Pb48ead \033]P96b5b4 \033]Pc0c5ce
\033]P65737e \033]Pbf616a \033]Pa3be8c \033]Pebcb8b
\033]P8fa1b3 \033]Pb48ead \033]P96b5b4 \033]Peff1f5
'
    clear
fi
