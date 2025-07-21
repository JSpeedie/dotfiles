##############################
#           Exports          #
##############################

# Set the default editor (`nvim` with `vim` as a fallback)
export EDITOR=vim
export VISUAL="$EDITOR"
# If the system has neovim, use that, otherwise use regular vim
if type nvim > /dev/null 2>&1; then
	alias vim="nvim"
	alias vimdiff='nvim -d'
	export EDITOR=nvim
	export VISUAL="$EDITOR"
fi


##############################
#         Completion         #
##############################

# Enable completion?
autoload -Uz compinit; compinit
# Highlight the currently selected completion option when cycling through
# completion options
zstyle ':completion:*' menu select
# Enable Shift+Tab for cycling backwards through the completion menu
bindkey '^[[Z' reverse-menu-complete


##############################
#           History          #
##############################

HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=40000
# Set the date format when noting the time a command was executed
HISTTIMEFORMAT="+%F %T.%N"

# Write the history file in the ':start:elapsed;command' format.
setopt extended_history
# Share history between all sessions.
setopt share_history


##############################
# Local and Global History   #
##############################

# Explanation of the Goal {{{
# The commands below change Zsh's `history` behaviour so that calling `history`
# shows you the global history (between all your Zsh sessions, including those
# that are currently active) while keeping the up-arrow, down-arrow history
# cycling behaviour limited to the local history, i.e. the history of that
# specific Zsh session.
#
# I have attempted to implement a similar `history` functionality in Bash, but
# this implementation in Zsh has the advantage of preserving the functionality
# of `![number]` when viewing the global history using `history`. I don't think
# it's possible to achieve the same functionality in Bash without some sort
# of plugin or external dependency. I'm not certain, though.
#
# The code belows only works if `share_history` is turned on. That means you
# should see `setopt share_history` somewhere else in this file!
# }}}

bindkey "${key[Up]}" up-line-or-local-history
bindkey "${key[Down]}" down-line-or-local-history

up-line-or-local-history() {
	zle set-local-history 1
	zle up-line-or-history
	zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
	zle set-local-history 1
	zle down-line-or-history
	zle set-local-history 0
}
zle -N down-line-or-local-history


##############################
#          Aliases           #
##############################

alias ls='ls --color=auto'
alias updatedot='~/scripts/updatedir ~/ ~/dotfiles/ ~/scripts/updatedir-dotfiles-filelist'
alias cdf='cd "$(find . -type d | fzf)"'


##############################
#           Prompt           #
##############################

setopt PROMPT_SUBST

# We surround our `tput` commands in `%{` and `%}` because those are the escape
# codes in Zsh that let it know that what is inbetween them should not be
# considered to occupy any space. Because we end up printing a string
# containing these "variables", and because `printf` uses `%` for its
# functionality, it is important that `prompt()` uses `echo -n` which doesn't
# care about `%`. If you really want to use `printf`, simply double all the
# `%`s in these variables since `%%` is the escaped way of printing `%` with
# `printf`.
reset="%{$(tput sgr0)%}"
# 'c_d' = invokes the foreground and background colour of the directory
c_d="%{$(tput setaf 15; tput setab 0; tput bold)%}"
success="%{$(tput setaf 0; tput setab 2)%}"
fail="%{$(tput setaf 0; tput setab 1)%}"

# Helper function for the 'prompt()' function
cur_dir() {
	printf "$(pwd | sed -e "s/\/home\/$USER/~/" | tr "\/" "\n" | tail -n 1)"
}

prompt() {
	if [[ $? -ne 0 ]]; then
		echo -n "${c_d}$(cur_dir) ${reset}${fail}\$${reset} "
	else
		echo -n "${c_d}$(cur_dir) ${reset}${success}\$${reset} "
	fi
}

PROMPT='$(prompt)'


##############################
#      FZF Key Bindings      #
##############################

__fzf_select() {
	find . | fzf
}

fzf-file-widget() {
	LBUFFER="${LBUFFER}$(__fzf_select)"
	local ret=$?
	zle reset-prompt
	return $ret
}

# Bind Ctrl+T to (essentially) the `__fzf_select` function
zle     -N            fzf-file-widget
bindkey -M emacs '^T' fzf-file-widget
bindkey -M vicmd '^T' fzf-file-widget
bindkey -M viins '^T' fzf-file-widget
