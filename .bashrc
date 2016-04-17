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

PS1='\[\e[0;35m\]\W\[\e[0m\] \[\e[1;30m\]$\[\e[0m\] '
