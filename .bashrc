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
alias record='ffmpeg -video_size 600x400 -framerate 60 -f x11grab -i :0.0+2020,100,nomouse prompt.mp4'
alias howconv='echo "convert -delay <ticks>x<ticks-per-second> -loop 0 out*gif <output-gif-file>"'
alias ctest='sh ~/scripts/colortest.sh'

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/base16-ocean.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

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

mdtopdf () {
	pandoc $1 --latex-engine=lualatex -o $2
}


PS1=$(prompt)
PS2='> '
export PS1 PS2
