﻿set history=1000                "Store lots of :cmdline history
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set errorbells                  "Beep when error occurs
set autoread                    "Reload files changed outside vim
set backspace=indent,eol,start  "Make backspace work properly
set laststatus=2                "Turn on status line
set exrc                        "Enable per-directory .vimrc files
set secure                      "Disable unsafe commands in local .vimrc files
set incsearch                   "Search incrementally instead of after I press enter
set number                      "Show line numbers
set nofoldenable                "Disable folding

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
" Adjust esckeys option timeout length
set timeoutlen=300

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" turn on syntax highlighting
syntax enable

" Automatically remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" ================ Install plugins =================
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Vundle setup
Plugin 'gmarik/Vundle.vim'

" Terraform support
Plugin 'hashivim/vim-terraform'
" Javascript support
Plugin 'pangloss/vim-javascript'
" Typescript support
Plugin 'leafgarland/typescript-vim'
" JSX support
Plugin 'mxw/vim-jsx'
" PostCSS support
Plugin 'alexlafroscia/postcss-syntax.vim'
" Kotlin support
Plugin 'udalov/kotlin-vim'

" Python indentation
Plugin 'Vimjas/vim-python-pep8-indent'
" Tabular to help tabularize code (required for markdown support)
Plugin 'godlygeek/tabular'
" Emmet for cool html coding
Plugin 'mattn/emmet-vim'
" Adding Adding commenting functionality
Plugin 'scrooloose/nerdcommenter'
" Airline status bar
Plugin 'bling/vim-airline'
" Git gutter
Plugin 'airblade/vim-gitgutter'
" Autocompletion
Plugin 'Valloric/YouCompleteMe'
" File search
Plugin 'ctrlpvim/ctrlp.vim'
" NERD Tree
Plugin 'scrooloose/nerdtree'
" Hard time mode to help learn vim
Plugin 'takac/vim-hardtime'
" Asynchronous Linting Engine
Plugin 'w0rp/ale'

" Color scheme
Plugin 'morhetz/gruvbox'


call vundle#end()
filetype on

" ================ Syntax association ===============
au BufRead,BufNewFile Jenkinsfile set filetype=groovy
au BufRead,BufNewFile *.jenkinsfile set filetype=groovy
au BufRead,BufNewFile .flake8 set filetype=dosini

" ================ YCM Settings =====================
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0

" ================ Emmet Settings ===================
imap <expr> <c-j> emmet#expandAbbrIntelligent("\<c-j>")

" ================ Hard Time Settings ===============
" let g:hardtime_default_on = 1

" ================ CtrlP Settings ===================
let g:ctrlp_map = '<c-p>'
let g:ctrlp_extensions = ['bookmarkdir']
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_custom_ignore = 'node_modules\|\.git$\|\.pyc$|.cache|.DS_Store|.terraform'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_show_hidden = 1

" ================ NERDTree Settings ================
let NERDTreeIgnore = ['\.\.$', '\.$', '__pycache__', 'node_modules', '\.git$', '\.pyc$', '.cache', '.DS_Store', '.terraform']
let NERDTreeShowHidden=1

" ================ GitGutter Settings ===============
set signcolumn=yes

" ================ Theme =====================
set t_Co=256
set t_ut=
colorscheme gruvbox

" ================ Turn Off Swap Files ==============
set noswapfile
set nobackup
set nowb

" ================ Indentation ======================
set autoindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

filetype plugin on
filetype indent on

" Display trailing spaces visually
set list listchars=trail:·,tab:»·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

set wildignore+=__pycache__

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Custom Commands ==================

command! -nargs=1 SetTab set shiftwidth=<args> softtabstop=<args> tabstop=<args>

" ================ Custom Mappings ==================
let mapleader = ","

" Close a buffer permanently
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>
" Shortcut to toggle NERDTree
map <leader>n :NERDTreeToggle<CR>
