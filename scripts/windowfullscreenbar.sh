hwb=$(scinf | awk '{print $4 - 30}');
w=$(scinf | awk '{print $3}');
x=$(scinf | awk '{print $1}');
y=$(scinf | awk '{print $2}');
waitron window_put_in_grid $w $hwb $x 30 $w $hwb
