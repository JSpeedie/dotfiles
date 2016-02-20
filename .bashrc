#
# ~/.bashrc
#

export GTK2_RC_FILES=/usr/share/themes/Paper/gtk-2.0/gtkrc

export VISUAL=vim
export EDITOR="$VISUAL"

alias ls='ls --color=auto'
alias dtest='sh ~/difftest.sh'
alias lock='sh ~/lock.sh'
alias updatedot='sh ~/updatedotgit.sh'

PS1='\[\e[0;35m\]\W\[\e[0m\] \[\e[1;30m\]$\[\e[0m\] '
