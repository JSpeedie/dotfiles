#
# ~/.bashrc
#

export GTK2_RC_FILES=/usr/share/themes/Paper/gtk-2.0/gtkrc

export VISUAL=vim
export EDITOR="$VISUAL"

alias ls='ls --color=auto'
alias dtest='sh ~/scripts/difftest.sh'
alias lock='sh ~/scripts/lock.sh'
alias updatedot='sh ~/scripts/updatedotgit.sh'
alias rec='ffmpeg -video_size 1920x1080 -framerate 60 -f x11grab -i :0.0+1920,0 output.mp4'
alias ctest='sh ~/scripts/colortest.sh'

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/base16-ocean.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

black="\[$(tput setaf 0)\]"
red="\[$(tput setaf 1)\]"
green="\[$(tput setaf 2)\]"
yellow="\[$(tput setaf 3)\]"
blue="\[$(tput setaf 4)\]"
purple="\[$(tput setaf 5)\]"
# Really greenish blue for base16-ocean
magenta="\[$(tput setaf 6)\]"
gray="\[$(tput setaf 7)\]"
darkgray="\[$(tput setaf 8)\]"
white="\[$(tput setaf 15)\]"
reset="\[$(tput sgr0)\]"

prompt () {
	# With " quotes, the directory doesn't change when I switch directories
	directory='$(pwd | sed -e "s/\/home\/$USER/~/" | tr "\/" "\n" | tail -n 1)'
	result='$(if [[ $? -ne 0 ]]; then \
				printf "\001$(tput setaf 8)\002$(pwd | sed -e "s/\/home\/$USER/~/" | tr "\/" "\n" | tail -n 1) \001$(tput setaf 1)\002$ \001$(tput sgr0)\002"; \
			else \
				printf "\001$(tput setaf 8)\002$(pwd | sed -e "s/\/home\/$USER/~/" | tr "\/" "\n" | tail -n 1) \001$(tput setaf 4)\002$ \001$(tput sgr0)\002"; \
			fi)'
	printf "${result}"
}


PS1=$(prompt)
PS2='> '
export PS1 PS2
