set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'klen/python-mode'
Bundle 'altercation/vim-colors-solarized'
Bundle 'tpope/vim-fugitive'
Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/syntastic'

filetype plugin indent on
syntax on
