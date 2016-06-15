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

# PS1='\[\e[0;35m\]\W\[\e[0m\] \[\e[1;30m\]$\[\e[0m\] '
# prompt () {
# 	_ERR=$?
# 	command_colour=7
# 	directory_colour=8
# 	exit_colour=4
# 	# if the last command run returned an error
# 	if [[ $_ERR -ne 0 ]]; then
# 		exit_colour=1
# 	fi
#   directory="$(tput setaf $directory_colour)$(pwd | sed -e "s/\/home\/$USER/~/" | tr "\/" "\n" | tail -n 1)"
#   ending="$(tput setaf $exit_colour) $"
#   printf "${directory}${ending}$(tput setaf $command_colour) "
# }

prompt () {
	command_colour=7
	directory_colour=8
	exit_colour=4
	ending="$(tput setaf $exit_colour) $"

	exit_color=6
	b="$(tput bold)"
	l="$(echo -n $b; tput setaf 0)"
	z="$(tput sgr0)"
	e="$(tput setaf $exit_color)"
	_ERR=$?
	# if the last command run returned an error
	if [ $_ERR -ne 0 ]; then
		exit_colour=1
	fi
	directory="$(pwd | sed -e "s/\/home\/$USER/~/" | tr "\/" "\n" | tail -n 1)"
	ending=" $"
	echo "$(tput setaf $directory_colour)${directory}$(tput setaf $exit_colour)${ending}$(tput setaf $command_colour) "
}

PS1='$(prompt)'
PS2='> '
export PS1 PS2

# PS1='$(prompt)'
