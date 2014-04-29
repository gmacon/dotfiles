set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'AndrewRadev/linediff.vim'
Bundle 'LaTeX-Box-Team/LaTeX-Box'
Bundle 'Valloric/YouCompleteMe'
Bundle 'altercation/vim-colors-solarized'
Bundle 'bling/vim-airline'
Bundle 'godlygeek/tabular'
Bundle 'klen/python-mode'
Bundle 'rking/ag.vim'
Bundle 'rodjek/vim-puppet'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'
Bundle 'vim-pandoc/vim-pandoc'

filetype plugin indent on

syntax on

set backspace=indent,eol,start

set ai hlsearch

set t_Co=256
set background=dark
colorscheme solarized

set colorcolumn=80

set mouse=a

set laststatus=2
let g:airline_powerline_fonts = 1
set guifont=Sauce\ Code\ Powerline:h11

let g:ycm_autoclose_preview_window_after_insertion = 1

set list listchars=tab:»-,trail:·

" Remove trailing whitespace
autocmd FileType puppet autocmd BufWritePre <buffer> :%s/\s\+$//e

" Python customizations
let g:pymode_lint_checkers = ['pyflakes', 'pep8']
let g:pymode_lint_ignore = "E501"
let g:pymode_rope = 0
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
