#!/bin/sh
tmpfile=$(mktemp /tmp/lockbg-XXXXXX.png)
grim - | convert - -scale 10% -blur 0x2 -resize 1000% $tmpfile
hyprlock -i $tmpfile
rm $tmpfile
