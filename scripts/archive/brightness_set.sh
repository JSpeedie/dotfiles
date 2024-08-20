if [[ -z $1 ]]; then
	echo "Missing percent argument. Exiting..."
	exit 1
else
	percent=$1

	# acpi_video0 is used for ati graphics card (amd cpu with no ded gpu?)
	if [[ -f /sys/class/backlight/intel_backlight/brightness ]]; then
		bright=$(cat /sys/class/backlight/intel_backlight/brightness)
		max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
		new_bright=$(echo "$bright $max $percent" | awk '{printf "%.0f\n", ((($3 / 100) * $2))}')
		if [[ $new_bright -gt $max ]]; then
			new_bright=$max;
		fi
		if [[ $new_bright -lt 0 ]]; then
			new_bright=0;
		fi
		echo "$new_bright" > /sys/class/backlight/intel_backlight/brightness

	elif [[ -f /sys/class/backlight/acpi_video0/brightness ]]; then
		bright=$(cat /sys/class/backlight/acpi_video0/brightness)
		max=$(cat /sys/class/backlight/acpi_video0/max_brightness)
		new_bright=$(echo "$bright $max $percent" | awk '{printf "%.0f\n", ((($3 / 100) * $2))}')
		if [[ $new_bright -gt $max ]]; then
			new_bright=$max;
		fi
		if [[ $new_bright -lt 0 ]]; then
			new_bright=0;
		fi
		echo "$new_bright" > /sys/class/backlight/acpi_video0/brightness
	else
		echo ""
	fi
fi


