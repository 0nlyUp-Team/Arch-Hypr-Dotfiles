#!/bin/bash
exec cava -p ~/.config/cava/cava_waybar_config | sed -u 'y/01234567/ ▁▂▃▄▅▆▇/'
