" Python interpreter setup
" These dunder strings will be replaced by fresh with the
" paths to the active interpreters when fresh is run.  This
" makes it work even when different pyenvs are set up.
let g:python3_host_prog = '__PY_BIN__/python3'
let g:javascript_bin_dir = '__JS_BIN__'

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

" Puppet
Plug 'rodjek/vim-puppet'
Plug 'godlygeek/tabular'

" SaltStack
Plug 'saltstack/salt-vim'

" Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

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

" Language Server Protocol
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'make release',
      \ }
Plug 'ambv/black'

" Generic
Plug 'editorconfig/editorconfig-vim'
Plug 'Konfekt/FastFold'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2'
Plug 'airblade/vim-rooter'
Plug 'neomake/neomake'
Plug 'ervandew/supertab'
Plug 'sbdchd/neoformat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'chriskempson/base16-vim'
Plug 'LucHermitte/lh-vim-lib'
Plug 'LucHermitte/local_vimrc'

call plug#end()

" General Configuration
set hlsearch
set ignorecase smartcase

let base16colorspace=256
colorscheme __COLORSCHEME__

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

set foldmethod=indent

" For live-edit detection to work properly:
set backupcopy=yes

let mapleader = "\<Space>"

" Language Client
let g:LanguageClient_settingsPath = 'language_settings.json'
let g:LanguageClient_loadSettings = 1
let g:LanguageClient_serverCommands = {
      \ 'rust': ['rustup', 'run', 'stable', 'rls'],
      \ 'python': [g:python3_host_prog, '-m', 'pyls'],
      \ 'javascript': [g:javascript_bin_dir . '/javascript-typescript-stdio'],
      \ 'javascript.jsx': [g:javascript_bin_dir . '/javascript-typescript-stdio'],
      \ }
nmap <unique> <silent> gd :call LanguageClient_textDocument_definition()<CR>
nmap <unique> <silent> <leader>r :call LanguageClient_textDocument_rename()<CR>
nmap <unique> <silent> gu :call LanguageClient_textDocument_references()<CR>
nmap <unique> <silent> <leader>h :call LanguageClient_textDocument_hover()<CR>

augroup LanguageClient_config
  autocmd!
  autocmd User LanguageClientStarted setlocal signcolumn=yes
  autocmd User LanguageClientStarted call ncm2#enable_for_buffer()
  autocmd User LanguageClientStopped setlocal signcolumn=auto
augroup END

" Yara
autocmd BufNewFile,BufRead *.yar,*.yara setfiletype yara

" Binary
nmap <unique> <silent> <leader>hx :Hexmode<CR>

" Fzf
nmap <unique> <silent> <leader>e :FzfGFiles<CR>
nmap <unique> <silent> <leader>E :FzfFiles<CR>
nmap <unique> <silent> <leader>w :FzfBuffers<CR>

" Neoformat
let g:neoformat_run_all_formatters = 1

let g:neoformat_python_isort = {
      \ 'exe': '__PY_BIN__/isort',
      \ 'args': ['-', '--quiet', '--use-parentheses', '--trailing-comma',],
      \ 'stdin': 1,
      \ }
let g:neoformat_python_black = {
      \ 'exe': '__PY_BIN__/black',
      \ 'stdin': 1,
      \ 'args': ['-', '2>/dev/null'],
      \ }
let g:neoformat_enabled_python = ['isort', 'black']
let g:neoformat_javascript_eslint_d = {
      \ 'exe': '__JS_BIN__/../../nvim/eslint_d_format_wrapper',
      \ 'args': ['"%:p"'],
      \ 'stdin': 1,
      \ }
let g:neoformat_enabled_javascript = ['eslint_d']

augroup autoneoformat
    autocmd!
    autocmd BufWritePre *.py,*.rs,*.js,*.jsx Neoformat
augroup END

" Neomake
let g:neomake_javascript_eslint_d_exe = '__JS_BIN__/eslint_d'
let g:neomake_javascript_enabled_makers = ['eslint_d']
let g:neomake_jsx_eslint_d_exe = '__JS_BIN__/eslint_d'
let g:neomake_jsx_enabled_makers = ['eslint_d']
:call neomake#configure#automake('rnw', 1000)

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

" Insert pdb trace
function InsertPdbTracePoint()
  :call append(line('.', 'import pdb; pdb.set_trace()  # TODO: Remove this'))
endfunction
nmap <unique> <slient> <leader>b :call InsertPdbTracePoint<CR>

" Write out literally
command Wl noautocmd w
command Wql noautocmd wq
