#!/bin/sh
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
[ -f ~/.xrandr ] && ~/.xrandr
xinput set-prop "DLL075B:01 06CB:76AF Touchpad" "libinput Tapping Enabled" 1
eval $(ssh-agent)
$HOME/src/rust-dwm-status/target/release/rust-dwm-status &
$HOME/bin/lightsOn.sh &
export _JAVA_AWT_WM_NONREPARENTING=1
#urxvtd -q -f -o
xscreensaver &
firefox &
thunderbird &
hexchat &
exec dwm
