#!/bin/bash

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')

temp=$(sensors | grep -m1 -oP '\+?\d+(\.\d+)?°?C' | head -n1)

read total used <<< $(free -m | awk '/^Mem:/ {print $2, $3}')
ram_used_gib=$(awk "BEGIN {printf \"%.1f\", $used/1024}")
ram_total_gib=$(awk "BEGIN {printf \"%.1f\", $total/1024}")
ram_display="${ram_used_gib}GiB/${ram_total_gib}GiB"

echo "{\"text\": \"󰻠 $cpu_usage 󰔄 $temp  $ram_display\"}"

