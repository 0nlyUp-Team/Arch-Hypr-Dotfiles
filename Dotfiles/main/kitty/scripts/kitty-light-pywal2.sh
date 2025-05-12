#!/bin/bash
WAL_COLORS="$HOME/.cache/wal/colors"
mapfile -t colors < "$WAL_COLORS"
KITTY_WAL="$HOME/.config/kitty/kitty.conf"
cat > "$KITTY_WAL" << EOF
foreground ${colors[0]}
background ${colors[6]}
selection_foreground ${colors[0]}
selection_background ${colors[4]}
color0  ${colors[0]}
color1  ${colors[1]}
color2  ${colors[2]}
color3  ${colors[3]}
color4  ${colors[4]}
color5  ${colors[5]}
color6  ${colors[6]}
color7  ${colors[7]}
color8  ${colors[8]}
color9  ${colors[9]}
color10 ${colors[10]}
color11 ${colors[11]}
color12 ${colors[12]}
color13 ${colors[13]}
color14 ${colors[14]}
color15 ${colors[15]}
wayland_titlebar_color system
font_size 10
font_family SF Mono
bold_font        auto
italic_font      auto
bold_italic_font auto
background_opacity 0.65
window_padding_width 8
window_margin_width 8
window_border_width 0
confirm_os_window_close 0
map ctrl+plus increase_font_size
map ctrl+minus decrease_font_size
map ctrl+0 reset_font_size
map ctrl+t launch --type=tab
map ctrl+tab next_tab
map ctrl+shift+tab previous_tab
hide_window_decorations yes
active_tab_title_template "{title}"
allow_remote_control yes
shell /bin/bash
EOF
