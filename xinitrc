#!/bin/sh
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
[ -f ~/.fehbg ] && sh ~/.fehbg
xinput set-prop "DLL075B:01 06CB:76AF Touchpad" "libinput Tapping Enabled" 1
eval $(ssh-agent)
~/.dotfiles/status.sh &
export _JAVA_AWT_WM_NONREPARENTING=1
#urxvtd -q -f -o
xscreensaver &
exec dwm
