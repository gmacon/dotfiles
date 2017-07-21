#!/bin/sh
[ -f ~/.xmodmap ] && xmodmap ~/.xmodmap
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
[ -f ~/.fehbg ] && sh ~/.fehbg
eval $(ssh-agent)
~/.dotfiles/status.sh &
export _JAVA_AWT_WM_NONREPARENTING=1
#urxvtd -q -f -o
exec dwm
