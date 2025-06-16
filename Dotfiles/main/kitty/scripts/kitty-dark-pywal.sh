#!/bin/bash
WAL_COLORS="$HOME/.cache/wal/colors"
mapfile -t colors < "$WAL_COLORS"
KITTY_WAL="$HOME/.config/kitty/kitty.conf"
cat > "$KITTY_WAL" << EOF
# Colors
  # Kitty Colors
    foreground ${colors[7]}
    background ${colors[0]}
    selection_foreground ${colors[0]}
    selection_background ${colors[0]}
    cursor ${colors[0]}
    cursor_text_color ${colors[0]}
    wayland_titlebar_color ${colors[0]}
    mark1_background ${colors[0]}
    mark1_foreground ${colors[0]}
    mark2_background ${colors[0]}
    mark2_foreground ${colors[0]}
    mark3_background ${colors[0]}
    mark3_foreground ${colors[0]}
  #Pywal16 scheme
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
# Config
  # Cursor
    cursor_shape_unfocused block
    cursor_shape block
  # Cursor Trail
    cursor_trail 1
    cursor_trail_decay 0.1 0.5
    cursor_trail_start_thresold 900
  # Font
    font_size 10
    font_family SF Mono
    bold_font        auto
    italic_font      auto
    bold_italic_font auto
  # Opacity
    background_opacity 0.6
  # Margin
    window_margin_width 8
  # Padding
    window_padding_width 8
  # Key Binds
    # Navigate in split terminal
      map ctrl+shift+enter     launch --location=hsplit --cwd=current
      map ctrl+shift+backslash launch --location=vsplit --cwd=current
      map ctrl+shift+left  neighboring_window left
      map ctrl+shift+right neighboring_window right
      map ctrl+shift+up    neighboring_window up
      map ctrl+shift+down  neighboring_window down
      map ctrl+shift+w close_window
    map ctrl+plus increase_font_size
    map ctrl+minus decrease_font_size
    map ctrl+0 reset_font_size
    map ctrl+t launch --type=tab
    map ctrl+tab next_tab
    map ctrl+shift+tab previous_tab
  # Shell
    shell /bin/bash
  # Etc
    confirm_os_window_close 0
    window_border_width 0
    hide_window_decorations yes
    active_tab_ticursor_trail 1tle_template "{title}"
    tab_bar_style powerline
    allow_remote_control yes
EOF

kitty @ set-colors --all "$KITTY_WAL"
