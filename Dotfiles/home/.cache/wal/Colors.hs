--Place this file in your .xmonad/lib directory and import module Colors into .xmonad/xmonad.hs config
--The easy way is to create a soft link from this file to the file in .xmonad/lib using ln -s
--Then recompile and restart xmonad.

module Colors
    ( wallpaper
    , background, foreground, cursor
    , color0, color1, color2, color3, color4, color5, color6, color7
    , color8, color9, color10, color11, color12, color13, color14, color15
    ) where

-- Shell variables
-- Generated by 'wal'
wallpaper="/home/unner/Wallpapers/trippy-purple.png"

-- Special
background="#0a0a11"
foreground="#c1c1c3"
cursor="#c1c1c3"

-- Colors
color0="#0a0a11"
color1="#525569"
color2="#61647A"
color3="#6F738A"
color4="#7B7DA1"
color5="#7E819B"
color6="#8F8EAC"
color7="#c1c1c3"
color8="#57576b"
color9="#525569"
color10="#61647A"
color11="#6F738A"
color12="#7B7DA1"
color13="#7E819B"
color14="#8F8EAC"
color15="#c1c1c3"
