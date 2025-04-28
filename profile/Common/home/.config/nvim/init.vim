" ================== Settings ====================

set history=1000                " Store lots of :cmdline history
set showmode                    " Show current mode down the bottom
set autoread                    " Reload files changed outside vim
set exrc                        " Enable per-directory .vimrc files
set secure                      " Disable unsafe commands in local .vimrc files
set number                      " Show line numbers
set clipboard=unnamedplus       " Makes yank/delete operations copy to clipboard
set incsearch                   " Search incrementally instead of after I press enter
set timeoutlen=300 		          " Adjust esckeys option timeout length
set hidden 			                " Buffers can exist in the background
set laststatus=2                " Enable status line
set guicursor=                  " Always use block cursor
set nohlsearch                  " Disable highlight search
set noshowmode                  " Don't show the mode
set noswapfile                  " Disable swap files
set termguicolors

" Set indentation to 2 spaces
set autoindent
set breakindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Automatically remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Turn on syntax highlighting
syntax enable

" Disabling netrw (recommended by nvim-tree)
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

" ================ Install plugins =================
call plug#begin('~/.local/share/nvim/plugged')

" Tree Sitter (Syntax Highlighting)
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Autopairs
Plug 'windwp/nvim-autopairs'

" Colorize color codes
Plug 'norcalli/nvim-colorizer.lua'

" File tree
Plug 'preservim/nerdtree'

" File search
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.2' }

" Status line
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'

" Useful tabularize function
Plug 'godlygeek/tabular'

" Color scheme
Plug 'folke/tokyonight.nvim'

call plug#end()

" ================ Mappings ================
let mapleader = ","

" ===== Editor Actions

" fzf file Search
nnoremap <c-p> <cmd>Telescope find_files<cr>
nnoremap <c-g> <cmd>Telescope live_grep<cr>

" NERDTree
noremap <c-n> :NERDTreeToggle<CR>
noremap <c-f> :NERDTreeFind<CR>

" ===== Editing Actions (arbitrary)

" ================ Common Settings ================

" Recognize Jenkinsfiles
autocmd BufNewFile,BufRead Jenkinsfile setf groovy
autocmd BufNewFile,BufRead *.Jenkinsfile setf groovy

" ================ Lua Plugin Settings ===========

lua require("autopairs-settings")
lua require("colorizer-settings")
lua require("treesitter-settings")
lua require("telescope-settings")

" ================ NERDTree Settings ==============
let NERDTreeIgnore = ['\.\.$', '\.$', '__pycache__', 'node_modules', '\.git$', '\.pyc$', '\.cache', '\.DS_Store', '\.terraform']
let NERDTreeShowHidden=1
autocmd FileType nerdtree setlocal signcolumn=no

" ================ Theme =========================
colorscheme tokyonight

" ================ Lightline Colorscheme =========
let g:lightline = {'colorscheme': 'tokyonight'}

" ================ Copy and Paste WSL ============
" let g:clipboard = {
"           \   'name': 'win32yank-wsl',
"           \   'copy': {
"           \      '+': 'win32yank.exe -i --crlf',
"           \      '*': 'win32yank.exe -i --crlf',
"           \    },
"           \   'paste': {
"           \      '+': 'win32yank.exe -o --lf',
"           \      '*': 'win32yank.exe -o --lf',
"           \   },
"           \   'cache_enabled': 0,
"           \ }
