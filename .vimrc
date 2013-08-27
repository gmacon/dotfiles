set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'rodjek/vim-puppet'
Bundle 'klen/python-mode'
Bundle 'altercation/vim-colors-solarized'
Bundle 'tpope/vim-fugitive'
Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/syntastic'

filetype plugin indent on

syntax on

set backspace=indent,eol,start

set ai hlsearch

set t_Co=256
set background=dark
colorscheme solarized

set colorcolumn=80

" Python customizations
let g:pymode_lint_checker = "pyflakes,pep8"
let g:pymode_lint_ignore = "E501"

" Puppet customizations
au FileType puppet setlocal tabstop=8 expandtab shiftwidth=2 softtabstop=2

" RST customizations
au FileType rst setlocal tabstop=8 expandtab shiftwidth=4 softtabstop=4
