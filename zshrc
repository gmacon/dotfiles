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

export WORKON_HOME=~/.virtualenvs

alias ssh='TERM=xterm-256color ssh'
alias vssh='TERM=xterm-256color vagrant ssh'

upto() { while [ $(basename $(pwd)) != $1 ]; do cd ..; done }

# OS X compatibilty
if [[ $(uname) == "Darwin" ]]; then
    # This function is defined as part of the system-wide bash config on OS X
    if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]]; then
	update_terminal_cwd() {
	    # Identify the directory using a "file:" scheme URL,
	    # including the host name to disambiguate local vs.
	    # remote connections. Percent-escape spaces.
	    local SEARCH=' '
	    local REPLACE='%20'
	    local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
	    printf '\e]7;%s\a' "$PWD_URL"
	}
    fi

    # path_helper is an OS X tool to configure system-wide search path
    if [[ -x /usr/libexec/path_helper ]]; then
	    eval `/usr/libexec/path_helper -s`
    fi

    # Homebrew
    export PATH="/usr/local/bin:/usr/local/sbin:${PATH}"
    export HOMEBREW_EDITOR=/usr/local/bin/mvim

    export CLICOLOR=1
fi

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
