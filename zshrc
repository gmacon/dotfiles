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
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt append_history
setopt share_history
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

export EDITOR="$(which nvim 2>/dev/null || which vim 2>/dev/null)"

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

# Go path
if [[ -d "${HOME}/go" ]]; then
    export GOPATH="${HOME}/go"
    export PATH="${PATH}:${GOPATH}/bin"
fi

# Local python install
export VIRTUAL_ENV_DISABLE_PROMPT=1
if [[ -d ${HOME}/.pyenv ]]; then
    export PYENV_ROOT="${HOME}/.pyenv"
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)";
    if [[ -d ${PYENV_ROOT}/plugins/pyenv-virtualenv ]]; then
        eval "$(pyenv virtualenv-init -)"
    fi
fi
