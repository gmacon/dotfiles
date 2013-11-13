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
Bundle 'godlygeek/tabular'

filetype plugin indent on

syntax on

set backspace=indent,eol,start

set ai hlsearch

set t_Co=256
set background=dark
colorscheme solarized

set colorcolumn=80

" Remove trailing whitespace
autocmd FileType puppet autocmd BufWritePre <buffer> :%s/\s\+$//e

" Python customizations
let g:pymode_lint_checker = "pyflakes,pep8"
let g:pymode_lint_ignore = "E501"
if has("python") && !empty($VIRTUAL_ENV)
	python <<EOF
import os
import sys
a = os.environ['VIRTUAL_ENV'] + '/bin/activate_this.py'
execfile(a, dict(__file__=a))
if 'PYTHONPATH' not in os.environ:
    os.environ['PYTHONPATH'] = ':'.join(sys.path)
EOF
endif
au FileType python setlocal tabstop=8

" Puppet customizations
au FileType puppet setlocal tabstop=8 expandtab shiftwidth=2 softtabstop=2

" RST customizations
au FileType rst setlocal tabstop=8 expandtab shiftwidth=4 softtabstop=4

" Syntastic customizations
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
			   \ 'passive_filetypes': ['python'] }
