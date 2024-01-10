# Install/Initialize all nvim plugins so nvim will work as intended

echo -n "About to configure plugins for neovim. Would you like to proceed? [Y/n] (enter=Y) "
read -a ANSWER
printf "\n"

# If the user wants to configure neovim.
if [[ ${ANSWER[*]} == "" || ${ANSWER[*]} == "Y" ]]; then
	echo -n "Neovim will now launch and attempt to install all the plugins specified in the init file. Give it time to complete this and then \":qa\" out. Are you ready to proceed? [Y/n] (enter=Y) "
	read -a ANSWER
	printf "\n"
	if [[ ${ANSWER[*]} == "" || ${ANSWER[*]} == "Y" ]]; then
		nvim -c "PlugInstall"
	else
		echo "User chose not to configure neovim. Continuing..."
	fi
fi


echo -n "About to configure Despacio colourscheme for neovim. Would you like to proceed? [Y/n] (enter=Y) "
read -a ANSWER
printf "\n"

# If the user wants to configure neovim.
if [[ ${ANSWER[*]} == "" || ${ANSWER[*]} == "Y" ]]; then
	if sed -i '/^.*MatchParen.*$/c\highlight MatchParen guifg=NONE guibg=#87afaf gui=reverse ctermfg=NONE ctermbg=109 cterm=reverse' ~/.vim/plugged/Despacio/colors/despacio.vim; then
		echo "Succeeded!"
	else
		echo "Failed to configure Despacio colourscheme"
	fi
fi
