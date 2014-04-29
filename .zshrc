# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}'
zstyle :compinstall filename '/home/gmacon/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
set -o HIST_IGNORE_DUPS
set -o HIST_IGNORE_SPACE
setopt appendhistory
bindkey -e
# End of lines configured by zsh-newuser-install

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export EDITOR=$(which vim)

export WORKON_HOME=~/.virtualenvs
[ -f /etc/bash_completion.d/virtualenvwrapper ] && source /etc/bash_completion.d/virtualenvwrapper

alias ssh='TERM=xterm-256color ssh'

TSL=$(tput tsl)
if [[ -n $TSL ]]; then
	export WINDOW_TITLE_FORMAT="$(tput tsl)%n@%M: %~\a"
	chpwd () {print -Pn $WINDOW_TITLE_FORMAT}
	print -Pn $WINDOW_TITLE_FORMAT
fi

unset GNOME_KEYRING_CONTROL

source ~/.fresh/build/shell.sh
