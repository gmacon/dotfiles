#!/bin/sh
[ -f ~/.xmodmap ] && xmodmap ~/.xmodmap
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
[ -f ~/.fehbg ] && sh ~/.fehbg
case $(hostname) in
	si-gam-d01.ctisl.gtri.org)
		xrandr --output VGA1 --preferred --primary --output HDMI1 --preferred --right-of VGA1
		xset s 180
		firefox &
		thunderbird &
		pidgin &
		;;
esac
xset +fp /usr/share/fonts/local
xset fp rehash
eval $(ssh-agent)
~/.dotfiles/status.sh &
export _JAVA_AWT_WM_NONREPARENTING=1
urxvtd -q -f -o
exec ~/.dotfiles/continuous-dwm
