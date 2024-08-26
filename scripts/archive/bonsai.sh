#!/bin/bash
# Prints a color text image of a bonsai tree
# Modifications from Github user 'JSpeedie' to support different
# terminal colourschemes
end=$'\e[0m'
color0=$'\e[0;30m'
color1=$'\e[0;31m'
color2=$'\e[0;32m'
color3=$'\e[0;33m'
color4=$'\e[0;34m'
color5=$'\e[0;35m'
color6=$'\e[0;36m'
color7=$'\e[0;37m'

color08=$'\e[1;30m'
color09=$'\e[1;31m'
color10=$'\e[1;32m'
color11=$'\e[1;33m'
color12=$'\e[1;34m'
color13=$'\e[1;35m'
color14=$'\e[1;36m'
color15=$'\e[1;37m'

color_array=($color0 $color1 $color2 $color3 $color4 $color5
$color6 $color7 $color8 $color9 $color10 $color11 $color12
$color13 $color14 $color15)

green=${color2}
brown=${color11}

if [[ ! -z $1 ]]; then
	# If the colour given is outside the range
	if [[ $1 -lt 0 || $1 -gt 15 ]]; then
		echo "First colour is outside of range"
		exit
	fi
	green=${color_array[$1]}

	if [[ ! -z $2 ]]; then
		# If the colour given is outside the range
		if [[ $2 -lt 0 || $2 -gt 15 ]]; then
			echo "Second colour is outside of range"
			exit
		fi
		brown=${color_array[$2]}
	fi
fi

# Credits to reddit user 'GuinansEyebrows' who provided the link
# 'https://x.eti.tf/tpG7d.sh'

echo -e "              ${green}&&"
echo -e "             ${green}&&&&&"
echo -e "           ${green}&&&\/& &&&"
echo -e "          ${green}&&${brown}|,/  |/${green}& &&"
echo -e "           ${green}&&${brown}/   /  /_${green}&  &&"
echo -e "             ${brown}\  {  |_____/_${green}&"
echo -e "             ${brown}{  / /          ${green}&&&"
echo -e "             ${brown}.\`. \\{___\________\/_\}"
echo -e "              ${brown}\} \}\{       \\"
echo -e "              ${brown}}\{\{         \\____${green}&"
echo -e "             ${brown}\{\}\{           \`${green}&&&"
echo -e "             ${brown}{{}             ${green}&&"
echo -e "       ${brown}, -=-~{ .-^- _"
echo -e "             \`}"
echo -e "              {${end}"
