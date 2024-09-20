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

" Setup Coc Extensions
let g:coc_global_extensions = [
      \ 'coc-sh',
      \ 'coc-json',
      \ 'coc-highlight',
      \ ]

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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Status line
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'

" Useful tabularize function
Plug 'godlygeek/tabular'

" Plugin to help create markdown tables
Plug 'dhruvasagar/vim-table-mode'

" Color scheme
Plug 'sainnhe/gruvbox-material'

call plug#end()

" ================ Mappings ================
let mapleader = ","

" ===== Editor Actions (ctrl-X)

" fzf file Search
noremap <c-p> :Files<CR>

" List Coc Actions
noremap <c-a> <Plug>(coc-codeaction-selected)<cr>
noremap <c-c> :CocCommand<cr>

" NERDTree
noremap <c-n> :NERDTreeToggle<CR>
noremap <c-f> :NERDTreeFind<CR>

" ===== Navigation Actions (gX)

" GoTo code navigation.
noremap <silent> gd <Plug>(coc-definition)
noremap <silent> gtd <Plug>(coc-type-definition)
noremap <silent> gi <Plug>(coc-implementation)
noremap <silent> gr <Plug>(coc-references)

" Use sd to show documentation in preview window.
nnoremap <silent> gdo :call <sid>show_documentation()<cr>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" ===== Editing Actions (arbitrary)

" Format buffer
noremap <silent> gf <Plug>(coc-format)

" Symbol renaming.
noremap <silent> rn <Plug>(coc-rename)

" ================ Common Settings ================

" Recognize Jenkinsfiles
autocmd BufNewFile,BufRead Jenkinsfile setf groovy
autocmd BufNewFile,BufRead *.Jenkinsfile setf groovy

" ================ Lua Plugin Settings ===========

lua require("autopairs-settings")
lua require("colorizer-settings")
lua require("treesitter-settings")

" ================ NERDTree Settings ==============
let NERDTreeIgnore = ['\.\.$', '\.$', '__pycache__', 'node_modules', '\.git$', '\.pyc$', '.cache', '.DS_Store', '.terraform']
let NERDTreeShowHidden=1
autocmd FileType nerdtree setlocal signcolumn=no

" ================ Theme =========================
set background=dark
let g:gruvbox_material_background = 'hard'
colorscheme gruvbox-material

" ================ Lightline Colorscheme =========
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'

" ================ Copy and Paste WSL ============
let g:clipboard = {
          \   'name': 'win32yank-wsl',
          \   'copy': {
          \      '+': 'win32yank.exe -i --crlf',
          \      '*': 'win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': 'win32yank.exe -o --lf',
          \      '*': 'win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 0,
          \ }
