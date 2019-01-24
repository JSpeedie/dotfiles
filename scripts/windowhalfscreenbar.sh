hwb=$(scinf | awk '{print $4 - 30}');
w=$(scinf | awk '{print $3}');
x=$(scinf | awk '{print $1}');
y=$(scinf | awk '{print $2}');
c=$(echo "$w" | awk '{print $1 / 2}')
a=$(echo "$x $w" | awk '{print $1 + ($2 / 2)}')
b=$(echo "$y 30" | awk '{print $1 + $2}')

if [[ "$1" == "left" ]]; then
	echo "waitron window_put_in_grid $w $hwb $x $b $c $hwb"
	waitron window_put_in_grid $w $hwb $x $b $c $hwb
elif [[ "$1" == "right" ]]; then
	echo "waitron window_put_in_grid $w $hwb $a $b $c $hwb"
	waitron window_put_in_grid $w $hwb $a $b $c $hwb
fi
