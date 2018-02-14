zmodload zsh/zprof

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

export EDITOR="$(command -v nvim || command -v vim)"
if command -v nvim >/dev/null; then
    alias vim='nvim'
fi

alias bd='. bd -s'

unset GNOME_KEYRING_CONTROL

source ~/.fresh/build/shell.sh
source ~/.fresh/build/vendor/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

sprunge () { cat "$@" | curl -F 'sprunge=<-' http://sprunge.us }

pyless () { pygmentize -O style=solarizeddark,bg=dark "$@" | less -R }

hless () { http --pretty=all --print=hb "$@" | less -R }

gitignore-std () {
    echo '#' $1 >>.gitignore
    cat ~/.fresh/source/github/gitignore/$1 >>.gitignore
    git add .gitignore
    git commit -m "Add standard ignore $1"
}

source ~/.fresh/build/vendor/zsh-autoenv/autoenv.zsh
