" Python interpreter setup
" These dunder strings will be replaced by fresh with the
" paths to the active interpreters when fresh is run.  This
" makes it work even when different pyenvs are set up.
let g:python_host_prog = '__PYTHON2__'
let g:python3_host_prog = '__PYTHON3__'

" Plugins
if empty(globpath(&rtp, 'autoload/plug.vim'))
  silent !curl -fLo ${XDG_CONFIG_HOME:-${HOME}/.config}/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin()
" Lightweight Markup Languages
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
let g:pandoc#formatting#equalprg = ""

" Jinja2 Templates
Plug 'alanhamlett/vim-jinja', {'commit': 'cb0ad0c43f4e753d44d0a8599f2be65dd1f24f04'}

" Python
Plug 'hynek/vim-python-pep8-indent'
Plug 'tmhedberg/SimpylFold'
Plug 'zchee/deoplete-jedi', { 'do': ':UpdateRemotePlugins' }
Plug 'davidhalter/jedi-vim'
Plug 'ambv/black'

" Puppet
Plug 'rodjek/vim-puppet'
Plug 'godlygeek/tabular'

" Rust
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer', { 'do': ':UpdateRemotePlugins' }

" SaltStack
Plug 'saltstack/salt-vim'

" LaTeX
Plug 'LaTeX-Box-Team/LaTeX-Box'

" Go
Plug 'fatih/vim-go'
Plug 'zchee/deoplete-go'

" Javascript
Plug 'pangloss/vim-javascript'

" Java
Plug 'ensime/ensime-vim', { 'do': ':UpdateRemotePlugins' }
Plug 'derekwyatt/vim-scala'

" Fzf
let g:fzf_command_prefix = 'Fzf'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Grako
Plug 'apalala/grako', { 'rtp': 'etc/vim' }

" Bro
Plug 'mephux/bro.vim'

" Yara
Plug 's3rvac/vim-syntax-yara'

" Binary
Plug 'fidian/hexmode'

Plug 'gu-fan/riv.vim'

" Generic
Plug 'editorconfig/editorconfig-vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Konfekt/FastFold'
Plug 'airblade/vim-rooter'
Plug 'ervandew/supertab'
Plug 'benekastah/neomake'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'altercation/vim-colors-solarized'
call plug#end()

" General Configuration
set hlsearch
set ignorecase smartcase

set background=light
colorscheme solarized

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
set completeopt=menuone,noinsert

set tabstop=8 softtabstop=4 shiftwidth=4 expandtab

let mapleader = "\<Space>"

" Rust
let g:rust_fold = 2
let g:racer_cmd = "racer"
let g:rustfmt_autosave = 1

" Jedi
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#show_call_signatures = 0

" Yara
autocmd BufNewFile,BufRead *.yar,*.yara setfiletype yara

" Binary
nmap <unique> <silent> <leader>hx :Hexmode<CR>

" deoplete
let g:deoplete#sources#go = 'vim-go'
let g:deoplete#enable_at_startup = 1
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.scala = '[^. *\t]\.\w*'

" Fzf
nmap <unique> <silent> <leader>e :FzfGFiles<CR>
nmap <unique> <silent> <leader>E :FzfFiles<CR>
nmap <unique> <silent> <leader>w :FzfBuffers<CR>

" Neomake
let g:neomake_python_enabled_makers = ['python', 'flake8']

let g:neomake_css_csslint_maker = {
    \ 'args': ['--quiet', '--format=compact'],
    \ 'errorformat': '%f: line %l\, col %c\, %t%*[a-zA-Z] - %m',
    \ }
let g:neomake_css_enabled_makers = ['csslint']
:call filter(g:neomake_css_enabled_makers, 'executable(v:val)')

let g:neomake_javascript_enabled_makers = ['standard', 'jshint', 'eslint', 'jscs', 'flow']
:call filter(g:neomake_javascript_enabled_makers, 'executable(v:val)')

" Toggle paste mode
nmap <unique> <silent> <leader>p :set paste!<CR>

" Toggle background
function! TogBG()
  let &background = ( &background == "dark" ? "light" : "dark" )
  if exists("g:colors_name")
    exe "colorscheme " . g:colors_name
  endif
endfunction
nmap <unique> <silent> <leader>bg :call TogBG()<CR>

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

" Location list
nmap <unique> <silent> <leader>lo :lopen<CR>
nmap <unique> <silent> <leader>lc :lclose<CR>
nmap <unique> <silent> <leader>ll :ll<CR>zv
nmap <unique> <silent> <leader>ln :lnext<CR>zv
nmap <unique> <silent> <leader>lp :lprev<CR>zv

" Quickfix list
nmap <unique> <silent> <leader>co :copen<CR>
nmap <unique> <silent> <leader>cc :cclose<CR>
nmap <unique> <silent> <leader>cl :cc<CR>zv
nmap <unique> <silent> <leader>cn :cnext<CR>zv
nmap <unique> <silent> <leader>cp :cprev<CR>zv

nmap <unique> <silent> <leader>hl :syntax sync fromstart<CR>

" End search highlight
nmap <unique> <silent> <leader>l :nohlsearch<CR>

" Copy current file and line
nmap <unique> <silent> <leader>fl :let @+=expand("%").":".line(".")<CR>

" Make sure backupdir exists
set backupdir=$HOME/.local/share/nvim/backup
:call mkdir(&backupdir, "p", 0700)

" Insert pdb trace
function InsertPdbTracePoint()
  :call append(line('.', 'import pdb; pdb.set_trace()  # TODO: Remove this'))
endfunction
nmap <unique> <slient> <leader>b :call InsertPdbTracePoint<CR>
