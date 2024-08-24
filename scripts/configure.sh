# Configure all the things installed in previous steps.

red=$'\e[1;31m'
end=$'\e[0m'

printf " ╔══════════════════════════════════════════════════════╗\n"
printf " ║                  3. Configure Setup                  ║\n"
printf " ╚══════════════════════════════════════════════════════╝\n"
echo

# Install vim-plug for vim and neovim plugins
# {{{
# Ask if the user wants to install vim-plug for managing vim plugins
echo -n "Would you like to install vim-plug for vim/neovim? [Y/n] (enter=Y): "
read -a ANSWER
printf "\n"

if [[ ${ANSWER[*]} == "Y" ]] || [[ ${ANSWER[*]} == "" ]]; then
	if curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
		printf "\n"
		printf "Attempted to install vim-plug.\n\n"
	else
		printf "\n"
		printf "WARNING: Possibly experienced an error attempting to install vim-plug\n\n."
	fi
else
	printf "Skipping vim-plug installation.\n\n"
fi
# }}}


# Use vim-plug to install the plugins specified in your neovim config
# {{{
echo -n "Would you like to configure the vim/neovim plugins found in your neovim config file? [Y/n] (enter=Y): "
read -a ANSWER
printf "\n"

# If the user wants to install all the neovim plugins.
# TODO: This should check to see if vim plug is installed some how
if [[ ${ANSWER[*]} == "Y" || ${ANSWER[*]} == "" ]]; then
	echo -n "Neovim will start up and run the necessary command. Give it time to complete and then \":qa\" out. Are you ready to proceed? [Y/n] (enter=Y): "
	read -a ANSWER
	printf "\n"

	if [[ ${ANSWER[*]} == "Y" || ${ANSWER[*]} == "" ]]; then
		if nvim -c "PlugInstall"; then
			printf "\n"
			printf "Attempted to install vim/neovim plugins.\n\n"
		else
			printf "\n"
			printf "WARNING: Possibly experienced an error attempting to install vim/neovim plugins.\n\n"
		fi
	else
		printf "Skipping vim/neovim plugins installation.\n\n"
	fi
else
	printf "Skipping vim/neovim plugins installation.\n\n"
fi
# }}}


printf "${red}WARNING:${end} You may have to run \":call coc#util#install()\" otherwise the next step will fail.\n\n"


# Install COC vim/neovim code completion language servers
# {{{
echo -n "Would you like to install COC code completion language servers. Give it time to complete this and then \":qa\" out. Are you ready to proceed? [Y/n] (enter=Y): "
read -a ANSWER
printf "\n"

if [[ ${ANSWER[*]} == "Y" || ${ANSWER[*]} == "" ]]; then
	echo -n "Neovim will start up and run the necessary command. Give it time to complete and then \":qa\" out. Are you ready to proceed? [Y/n] (enter=Y): "
	read -a ANSWER
	printf "\n"

	if [[ ${ANSWER[*]} == "Y" || ${ANSWER[*]} == "" ]]; then
		if nvim -c "CocInstall coc-clangd coc-sh coc-vimlsp coc-rust-analyzer"; then
			printf "\n"
			printf "Attempted to install COC code completion language servers.\n\n"
		else
			printf "\n"
			printf "WARNING: Possibly experienced an error attempting to install COC code completion language servers.\n\n"
		fi
	fi
else
	printf "Skipping COC code completion language servers installation.\n\n"
fi
# }}}

# Add nvim-cmp highlighting to the Ayu colourscheme
# {{{
echo -n "Would you like to add nvim-cmp highlighting to the Ayu colourscheme? [Y/n] (enter=Y): "
read -a ANSWER
printf "\n"

# If the user wants to fix the neovim colourscheme
if [[ ${ANSWER[*]} == "Y" || ${ANSWER[*]} == "" ]]; then
	printf "
	============================================================================
	nvim-cmp
	\" ---------
	\" Matching Letters: blue text with no bg
	exe \"hi! CmpItemAbbrMatch\"      .s:fg_tag .s:bg_none .s:fmt_none
	exe \"hi! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch\"
	\" Deprecated Recommendations: gray text with no bg, struckthrough
	exe \"hi! CmpItemAbbrDeprecated  gui=strikethrough \" .s:fg_comment .s:bg_none
	\" Default: white text with orange bg
	exe \"hi! CmpItemKind\"           .s:fg_bg .s:bg_function .s:fmt_none
	\" Module: white text with red bg
	exe \"hi! CmpItemKindModule\"     .s:fg_bg .s:bg_markup .s:fmt_none
	\" Interface: white text with purple bg
	exe \"hi! CmpItemKindInterface\"  .s:fg_bg .s:bg_constant .s:fmt_none
	\" Struct: white text with orange bg
	exe \"hi! CmpItemKindStruct\"     .s:fg_bg .s:bg_function .s:fmt_none
	\" Enum: white text with green bg
	exe \"hi! CmpItemKindEnum\"       .s:fg_bg .s:bg_string .s:fmt_none
	exe \"hi! link CmpItemKindEnumMember CmpItemKindEnum\"
	\" Methods: white text with yellow bg
	exe \"hi! CmpItemKindMethod\"     .s:fg_bg .s:bg_operator .s:fmt_none
	\" Functions: white text with yellow bg
	exe \"hi! CmpItemKindFunction\"   .s:fg_bg .s:bg_operator .s:fmt_none
	\" Variable: white text with blue bg
	exe \"hi! CmpItemKindVariable\"   .s:fg_bg .s:bg_tag .s:fmt_none
	\" Keyword: white text with teal bg
	exe \"hi! CmpItemKindKeyword\"    .s:fg_bg .s:bg_regexp .s:fmt_none
	\" Constant: white text with teal bg
	exe \"hi! CmpItemKindConstant\"   .s:fg_bg .s:bg_regexp .s:fmt_none
	\" Text: white text with gray bg
	exe \"hi! CmpItemKindText\"       .s:fg_bg .s:bg_guide .s:fmt_none
	============================================================================

	Copy the code in between the lines and paste it at the end of: 
	.local/share/nvim/lazy/ayu/colors/ayu.vim\n\n"
else
	printf "Skipping MatchParen fix for Despacio.\n\n"
fi
# }}}

# Apply the MatchParen fix to the Despacio colourscheme
# {{{
echo -n "Would you like to apply the MatchParen fix to the Despacio colourscheme? [Y/n] (enter=Y): "
read -a ANSWER
printf "\n"

# If the user wants to fix the neovim colourscheme
if [[ ${ANSWER[*]} == "Y" || ${ANSWER[*]} == "" ]]; then
	if sed -i '/^.*MatchParen.*$/c\highlight MatchParen guifg=NONE guibg=#87afaf gui=reverse ctermfg=NONE ctermbg=109 cterm=reverse' ~/.vim/plugged/Despacio/colors/despacio.vim; then
		if sed -i '/^.*PmenuSel.*$/c\highlight PmenuSel guifg=#eeeeee guibg=NONE gui=NONE ctermfg=255 ctermbg=NONE cterm=NONE' ~/.vim/plugged/Despacio/colors/despacio.vim; then
			printf "\n"
			printf "Attempted to fix MatchParen highlighting in Despacio colourscheme.\n\n"
		else
			printf "\n"
			printf "WARNING: Possibly experienced an error attempting to fix MatchParen highlighting in Despacio colourscheme.\n\n"
		fi
	else
		printf "\n"
		printf "WARNING: Possibly experienced an error attempting to fix MatchParen highlighting in Despacio colourscheme.\n\n"
	fi
else
	printf "Skipping MatchParen fix for Despacio.\n\n"
fi
# }}}
