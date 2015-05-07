" Plugins
if empty(glob('~/.nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin()
" Lightweight Markup Languages
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" Generic
"Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-sensible'
call plug#end()

" General Configuration
set hlsearch

set hidden

set colorcolumn=+1

set mouse=a

set number
set scrolloff=5

set list listchars=tab:»-,trail:·,extends:>,precedes:<,nbsp:+

" Toggle paste mode
map <unique> <silent> <F2> :set paste!<CR>

" Strip trailing whitespace (and save cursor position) when saving files
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Split line at cursor
imap <C-c> <CR><Esc>O

