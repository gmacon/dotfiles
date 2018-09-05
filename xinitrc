#!/bin/sh

xinput set-prop "DLL075B:01 06CB:76AF Touchpad" "libinput Tapping Enabled" 1
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
if [ -f ~/.xrandr ]; then
	~/.xrandr
	if which srandrd >/dev/null 2>&1; then
		srandrd $HOME/.xrandr
	fi
fi

export _JAVA_AWT_WM_NONREPARENTING=1

eval $(ssh-agent)
$HOME/src/rust-dwm-status/target/release/rust-dwm-status &
#urxvtd -q -f -o

xset s 300
xset dpms 300
xss-lock -- sxlock -f '-*-dejavu sans-*-*-*-*-*-*-*-*-*-*-*-*' &

firefox &
thunderbird &
hexchat &

exec dwm
