#!/usr/bin/bash

# Nuke all internal spawns when script dies
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM

BARS=8;
FRAMERATE=44;
EQUILIZER=1;

# Get script options
while getopts 'b:f:m:eh' flag; do
    case "${flag}" in
        b) BARS="${OPTARG}" ;;
        f) FRAMERATE="${OPTARG}" ;;
        e) EQUILIZER=0 ;;
        h)
            echo "caway usage: caway [ options ... ]"
            echo "where options include:"
            echo
            echo "  -b <integer>  (Number of bars to display. Default 8)"
            echo "  -f <integer>  (Framerate of the equilizer. Default 60)"
            echo "  -e            (Disable equilizer. Default enabled)"
            echo "  -h            (Show help message)"
            exit 0
            ;;
    esac
done

bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# creating "dictionary" to replace char with bar + thin space " "
i=0
while [ $i -lt ${#bar} ]
do
    dict="${dict}s/$i/${bar:$i:1} /g;"
    i=$((i=i+1))
done
#sleep 1
# Remove last extra thin space
dict="${dict}s/.$//;"

clean_create_pipe() {
    if [ -p $1 ]; then
        unlink $1
    fi
    mkfifo $1
}

kill_pid_file() {
    if [[ -f $1 ]]; then
        while read pid; do
            { kill "$pid" && wait "$pid"; } 2>/dev/null
        done < $1
    fi
}

# PID of the cava process and while loop launched from the script
cava_waybar_pid="/tmp/cava_waybar_pid"

# Clean pipe for cava
cava_waybar_pipe="/tmp/cava_waybar.fifo"
clean_create_pipe $cava_waybar_pipe
#sleep 0.20
# Custom cava config
cava_waybar_config="/tmp/cava_waybar_config"
#sleep 0.20
echo "
[general]
mode = normal
framerate = $FRAMERATE
bars = $BARS

[output]
method = raw
raw_target = $cava_waybar_pipe
data_format = ascii
ascii_max_range = 4
" > $cava_waybar_config

# Clean pipe for playerctl
playerctl_waybar_pipe="/tmp/playerctl_waybar.fifo"
clean_create_pipe $playerctl_waybar_pipe

# playerctl output into playerctl_waybar_pipe
playerctl -a metadata --format '{"text": "{{artist}} - {{title}}", "tooltip": " {{playerName}} : {{markup_escape(artist)}} - {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F >$playerctl_waybar_pipe &

# Read the playerctl o/p via its fifo pipe
while read -r line; do
    # Kill the cava process to stop the input to cava_waybar_pipe
    kill_pid_file $cava_waybar_pid

    STATUS=$(echo $line | jq -r '.class')
    
    if [[ $STATUS == "Playing" ]]; then
        # If the class is "Playing" and equilizer is enabled, then show the cava equilizer
        if [[ $EQUILIZER == 1 ]]; then
            # cava output into cava_waybar_pipe
            cava -p $cava_waybar_config >$cava_waybar_pipe &
            # Save the PID of child process
            echo $! > $cava_waybar_pid
            
            # Read the cava o/p via its fifo pipe
            while read -r cmd2; do
                #sleep 0.014
                # Change the "text" key to bars
                echo "$line" | jq --arg a $(echo $cmd2 | sed "$dict") '.text = $a' --unbuffered --compact-output
            done < $cava_waybar_pipe & # Do this fifo read in background
            
            # Save the while loop PID into the file as well
            echo $! >> $cava_waybar_pid
        else
            echo "$line" | jq --unbuffered --compact-output
        fi
    fi
    # Если статус не "Playing", то ничего не выводим

done < $playerctl_waybar_pipe
