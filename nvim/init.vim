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

" TOML
Plug 'cespare/vim-toml'

" Jinja2 Templates
Plug 'alanhamlett/vim-jinja', {'commit': 'cb0ad0c43f4e753d44d0a8599f2be65dd1f24f04'}

" Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Fzf
let g:fzf_command_prefix = 'Fzf'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Binary
Plug 'fidian/hexmode'

" ALE
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_sign_column_always = 1
let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'javascript': ['eslint'],
      \ 'python': ['isort', 'black'],
      \ 'rust': ['rustfmt'],
      \ }
let g:ale_linters = {
      \ 'javascript': ['eslint', 'flow_ls'],
      \ 'python': ['flake8', 'mypy', 'pylint', 'pyls'],
      \ 'rust': ['rls'],
      \ }
let g:ale_rust_rls_toolchain = 'stable'
let g:ale_python_pyls_config =
      \ {
      \   'pyls': {
      \     'plugins': {
      \       'mccabe': {'enabled': v:false},
      \       'pycodestyle': {'enabled': v:false},
      \       'pydocstyle': {'enabled': v:false},
      \       'pyflakes': {'enabled': v:false},
      \     }
      \   }
      \ }
Plug 'w0rp/ale'

" Generic
Plug 'editorconfig/editorconfig-vim'
Plug 'Konfekt/FastFold'
Plug 'roxma/nvim-yarp'
Plug 'direnv/direnv.vim'
Plug 'airblade/vim-rooter'
Plug 'ervandew/supertab'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'chriskempson/base16-vim'
Plug 'SirVer/ultisnips'
Plug 'andrewstuart/vim-kubernetes'

call plug#end()

" General Configuration
set hlsearch
set ignorecase smartcase

let base16colorspace=256
colorscheme $LC_COLORSCHEME

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

let g:rooter_silent_chdir = 1
let g:rooter_patterns = ['.git', '.git/', 'pyproject.toml', 'package.json', 'Cargo.toml']

" Language Client
nmap <unique> <silent> gd :ALEGoToDefinition<CR>
nmap <unique> <silent> gu :ALEFindReferences<CR>
nmap <unique> <silent> <leader>h :ALEHover<CR>

" UltiSnips
let g:UltiSnipsExpandTrigger = '<c-j>'

" JavaScript
let g:javascript_plugin_flow = 1

" Fzf
nmap <unique> <silent> <leader>e :FzfGFiles<CR>
nmap <unique> <silent> <leader>E :FzfFiles<CR>
nmap <unique> <silent> <leader>w :FzfBuffers<CR>

" Toggle paste mode
nmap <unique> <silent> <leader>p :set paste!<CR>

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

" Write out literally
command Wl noautocmd w
command Wql noautocmd wq
