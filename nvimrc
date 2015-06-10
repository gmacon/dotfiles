" Python interpreter setup
" These dunder strings will be replaced by fresh with the
" paths to the active interpreters when fresh is run.  This
" makes it work even when different pyenvs are set up.
let g:python_host_prog = '__PYTHON2__'
let g:python3_host_prog = '__PYTHON3__'

" Plugins
if empty(glob('~/.nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin()
" Lightweight Markup Languages
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" Jinja2 Templates
Plug 'mitsuhiko/vim-jinja'

" Python
Plug 'hynek/vim-python-pep8-indent'
Plug 'davidhalter/jedi-vim'
Plug 'tmhedberg/SimpylFold'

" Puppet
Plug 'rodjek/vim-puppet'
Plug 'godlygeek/tabular'

" LaTeX
Plug 'LaTeX-Box-Team/LaTeX-Box'

" Go
Plug 'fatih/vim-go'

" Generic
Plug 'Shougo/unite.vim'
Plug 'airblade/vim-rooter'
Plug 'ervandew/supertab'
Plug 'benekastah/neomake'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
call plug#end()

" General Configuration
set hlsearch

set hidden
set nowrap

set colorcolumn=+1

set mouse=a

set number
set scrolloff=5

set backspace=indent,eol,start

set fillchars=vert:│
set list listchars=tab:→\ ,trail:·,precedes:«,extends:»

set wildmenu wildmode=longest:full,full
set completeopt=menuone,longest

" Toggle paste mode
map <unique> <silent> <F2> :set paste!<CR>

" Fold & unfold
nnoremap <space> za

" Switching and editing
nnoremap <leader>w :Unite -start-insert buffer<cr>
nnoremap <leader>e :Unite -start-insert file_rec/neovim<cr>
function! s:UniteSettings()
  imap <buffer> <Esc> <Plug>(unite_exit)
endfunction
autocmd FileType unite :call s:UniteSettings()

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

" Python
autocmd FileType python setlocal tw=79 ts=8 sts=4 sw=4 et
autocmd BufWritePost *.py Neomake
let g:jedi#show_call_signatures = 2

" Puppet
let g:neomake_puppet_puppetlint_maker = {
      \ 'exe': 'puppet-lint',
      \ 'args': ['--log-format', '"%{path}:%{line}:%{column}:%{kind}:[%{check}] %{message}"'],
      \ 'errorformat': '"%f:%l:%c:%t%*[a-zA-Z]:%m"',
      \ }
let g:neomake_puppet_puppet_maker = {
      \ 'args': ['parser', 'validate'],
      \ 'errorformat': '%t%*[a-zA-Z]: %m at %f:%l',
      \ }
let g:neomake_puppet_enabled_makers = ['puppetlint', 'puppet']
autocmd BufWritePost *.pp Neomake

" Go
let g:go_bin_path = expand("~/.gotools")
