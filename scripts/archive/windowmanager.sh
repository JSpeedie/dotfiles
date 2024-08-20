# To provide my tools for window management
if git clone https://github.com/JSpeedie/wmcontrib wmcontribGit; then
	cd wmcontribGit
	sudo make install
	cd ..
else
	echo "[ERROR]: Failed to install wmcontrib"
fi
# To provide wmutils for window management
if git clone https://github.com/wmutils/core wmutilscoreGit; then
	cd wmutilscoreGit
	make
	sudo make install
	cd ..
else
	echo "[ERROR]: Failed to install wmutils/core"
fi

# To provide wmutils code for other window management tools
if git clone https://github.com/wmutils/libwm wmutilslibwmGit; then
	cd wmutilslibwmGit
	make
	sudo make install
	cd ..
else
	echo "[ERROR]: Failed to install wmutils/libwm"
fi

# To provide basic window management function
if git clone https://github.com/tudurom/windowchef windowchefGit; then
	cd windowchefGit
	make
	sudo make install
	cd ..
else
	echo "[ERROR]: Failed to install windowchef"
fi
# To create rules for more sensible default actions
if git clone https://github.com/tudurom/ruler rulerGit; then
	cd rulerGit
	make
	sudo make install
	cd ..
else
	echo "[ERROR]: Failed to install ruler"
fi
