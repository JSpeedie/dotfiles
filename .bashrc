#
# ~/.bashrc
#

export GTK2_RC_FILES=/usr/share/themes/Industrial/gtk-2.0/gtkrc nautilus

[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
