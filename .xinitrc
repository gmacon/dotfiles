#!/bin/sh
xmodmap ~/.xmodmap
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.fehbg ]] && sh ~/.fehbg
xset s 180
eval $(ssh-agent)
~/.dotfiles/status.sh &
export _JAVA_AWT_WM_NONREPARENTING=1
exec ~/.dotfiles/continuous-dwm
