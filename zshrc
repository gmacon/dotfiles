fpath=(~/.fresh/build/completion $fpath)
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

setopt correct

# enable color support of ls and also add handy aliases
if [[ -x /usr/bin/dircolors ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export EDITOR=$(which vim)

alias ssh='TERM=xterm-256color ssh'
alias vssh='TERM=xterm-256color vagrant ssh'

upto() { while [ $(basename $(pwd)) != $1 ]; do cd ..; done }

unset GNOME_KEYRING_CONTROL

source ~/.fresh/build/shell.sh
source ~/.fresh/build/vendor/zsh-syntax-highlighting.zsh

# Local ruby install
if [[ -d $HOME/.rbenv ]]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

# Local perl install
if [[ -d $HOME/perl5 ]]; then
    eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
fi

# Local go install
if [[ -d /usr/local/go ]]; then
    export PATH="$PATH:/usr/local/go/bin"
fi

# Local python install
if which pyenv > /dev/null; then
    eval "$(pyenv init -)";
    if which pyenv-virtualenv-init > /dev/null; then
	eval "$(pyenv-virtualenv-init -)"
    fi
fi
