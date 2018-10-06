set history=1000                " Store lots of :cmdline history
set showmode                    " Show current mode down the bottom
set autoread                    " Reload files changed outside vim
set exrc                        " Enable per-directory .vimrc files
set secure                      " Disable unsafe commands in local .vimrc files
set number                      " Show line numbers
set clipboard=unnamed           " Makes yank/delete operations copy to clipboard
set incsearch                   " Search incrementally instead of after I press enter
set timeoutlen=300 		          " Adjust esckeys option timeout length
set hidden 			                " Buffers can exist in the background
set laststatus=2                " Enable status line

" Automatically remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Turn on syntax highlighting
syntax enable

" ================ Install plugins =================
call plug#begin('~/.local/share/nvim/plugged')

" Deoplete completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Typescript
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}

" File search
Plug '/usr/bin/fzf'
Plug 'junegunn/fzf.vim'
" NERD Tree
Plug 'scrooloose/nerdtree'
" Status line
Plug 'itchyny/lightline.vim'
" Sublime multiple cursors
Plug 'terryma/vim-multiple-cursors'
" Common Unix commands
Plug 'tpope/vim-eunuch'
" Editor config support
Plug 'editorconfig/editorconfig-vim'
" Asynchronous Linting Engine
Plug 'w0rp/ale'
" Show Github changes
Plug 'airblade/vim-gitgutter'

" Color scheme
Plug 'morhetz/gruvbox'

call plug#end()

" ================ Deoplete Settings ==============
let g:deoplete#enable_at_startup = 1

" ================ fzf Settings ===================
let mapleader = ","

" ================ fzf Settings ===================
noremap <c-p> :Files<CR>

" ================ NERDTree Settings ==============
let NERDTreeIgnore = ['\.\.$', '\.$', '__pycache__', 'node_modules', '\.git$', '\.pyc$', '.cache', '.DS_Store', '.terraform']
let NERDTreeShowHidden=1
noremap <leader>n :NERDTreeToggle<CR>

" ================ Theme =========================
" let g:gruvbox_contrast_dark = 'hard'
" set t_Co=256
" set t_ut=
set background=dark
colorscheme gruvbox

" ================ Indentation ===================
set autoindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
