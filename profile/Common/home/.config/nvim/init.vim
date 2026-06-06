" ================== Settings ====================

set exrc
set number
set clipboard=unnamedplus
set timeoutlen=300
set guicursor=
set nohlsearch
set noswapfile
set termguicolors

" Set indentation to 2 spaces
set breakindent
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Automatically remove trailing whitespace
augroup TrimWhitespace
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
augroup END

" Disabling netrw (required for nvim-tree)
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

" ================ Install plugins =================
call plug#begin('~/.local/share/nvim/plugged')

" Autopairs
Plug 'windwp/nvim-autopairs'

" Colorize color codes
Plug 'norcalli/nvim-colorizer.lua'

" File tree
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

" File search (fzf-lua)
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

" Status line
Plug 'itchyny/lightline.vim'

" Useful tabularize function
Plug 'godlygeek/tabular'

" Color scheme
Plug 'folke/tokyonight.nvim'

call plug#end()

" ================ Mappings ================
let mapleader = ","

" fzf-lua
nnoremap <c-p> <cmd>lua require('fzf-lua').files()<CR>
nnoremap <c-g> <cmd>lua require('fzf-lua').live_grep()<CR>

" NvimTree
nnoremap <c-n> <cmd>NvimTreeToggle<CR>
nnoremap <c-f> <cmd>NvimTreeFindFile<CR>

" ================ Common Settings ================

" Recognize Jenkinsfiles
augroup Jenkinsfile
  autocmd!
  autocmd BufNewFile,BufRead Jenkinsfile,*.Jenkinsfile setf groovy
augroup END

" ================ Theme =========================
colorscheme tokyonight
let g:lightline = {'colorscheme': 'tokyonight'}

" ================ Plugin Settings ===============

" Initialize plugins
lua require("fzf-lua").setup({})
lua require("nvim-tree").setup()
