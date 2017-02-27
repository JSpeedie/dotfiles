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
alias record='ffmpeg -video_size 600x400 -framerate 60 -f x11grab -i :0.0+2020,100,nomouse prompt.mp4'
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

directory() {
	printf "$(pwd | sed -e "s/\/home\/$USER/~/" | tr "\/" "\n" | tail -n 1)"
}

prompt () {
	result='$(if [[ $? -ne 0 ]]; then \
				printf "\001$(tput setaf 8)\002$(directory) \001$(tput setaf 1)\002# \001$(tput sgr0)\002"; \
			else \
				printf "\001$(tput setaf 8)\002$(directory) \001$(tput setaf 7)\002# \001$(tput sgr0)\002"; \
			fi)'
	printf "${result}"
}

mdtopdf () {
	pandoc $1 --latex-engine=lualatex -o $2
}

PS1=$(prompt)
PS2='> '
export PS1 PS2
