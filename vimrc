set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'gmarik/vundle.vim'

" LaTeX
Plugin 'LaTeX-Box-Team/LaTeX-Box'

" Python
Plugin 'klen/python-mode'

" Puppet
Plugin 'rodjek/vim-puppet'

" Ansible
Plugin 'chase/vim-ansible-yaml'

" Lightweight Markup Languages
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'

" HTML-Jinja2
Plugin 'mitsuhiko/vim-jinja'

" Javascript
Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'marijnh/tern_for_vim'

" Generic
Plugin 'AndrewRadev/linediff.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'godlygeek/tabular'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-sensible'
Plugin 'kien/ctrlp.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'dhruvasagar/vim-table-mode'

call vundle#end()

set hlsearch

set hidden

set t_Co=256
set background=dark
colorscheme solarized

set colorcolumn=+1

set mouse=a

set number

let g:airline_powerline_fonts = 1
set guifont=Sauce\ Code\ Powerline:h11

let g:ycm_autoclose_preview_window_after_insertion = 1

set list listchars=tab:»-,trail:·,extends:>,precedes:<,nbsp:+

" Toggle paste mode
map <unique> <silent> <F2> :set paste!<CR>

" Remove trailing whitespace
autocmd FileType puppet autocmd BufWritePre <buffer> :%s/\s\+$//e

" Split line at cursor
imap <C-c> <CR><Esc>O

" Pandoc customizations
let g:pandoc#formatting#mode = 'hA'

" Python customizations
let g:pymode_lint_on_write = 0
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

" Syntastic customizations
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_auto_loc_list = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_python_checkers = ['pyflakes', 'pep8', 'python']
