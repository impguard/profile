" ================ General Config ====================
set number                      "Line numbers are good
set cursorline                  "Show which line I'm on
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set backspace=indent,eol,start  "Make backspace work properly
set laststatus=2                "Turn on status line
set exrc                        "Enable per-directory .vimrc files
set secure                      "Disable unsafe commands in local .vimrc files
set incsearch                   "Search incrementally instead of after I press enter

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
" Adjust esckeys option timeout length
set timeoutlen=500

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
" Coffeescript support
Plugin 'kchmck/vim-coffee-script'
" Scala support
Plugin 'derekwyatt/vim-scala'
" Tabular to help tabularize code (required for markdown support)
Plugin 'godlygeek/tabular'
" Markdown support
Plugin 'plasticboy/vim-markdown'
" IR Black theme
Plugin 'wesgibbs/vim-irblack'
" Airline status bar
Plugin 'bling/vim-airline'
" Git gutter
Plugin 'airblade/vim-gitgutter'
" Easy motion plugin for augmented motion controls
Plugin 'easymotion/vim-easymotion'
" Surround plugin to to handle 'surroundings'
Plugin 'tpope/vim-surround'
" Autocompletion helper
Plugin 'ervandew/supertab'
" File search
Plugin 'ctrlpvim/ctrlp.vim'
" Hard time mode to help learn vim
Plugin 'takac/vim-hardtime'
call vundle#end()
filetype on

" ================ Easy Motion Settings =============
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" ================ CtrlP Settings ===================
let g:ctrlp_map = '<c-p>'
let g:ctrlp_extensions = ['bookmarkdir']
let g:ctrlp_open_new_file = 'r'

" ================ Setup Colors =====================
colorscheme ir_black

" ================ Turn Off Swap Files ==============
set noswapfile
set nobackup
set nowb

" ================ Indentation ======================
set autoindent
" set smartindent " Disable when using filetype indentation
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

filetype plugin on
filetype indent on

" Display trailing spaces visually
set list listchars=trail:·,tab:»·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

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

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Custom Commands ==================

command -nargs=1 SetTab set shiftwidth=<args> softtabstop=<args> tabstop=<args>

" ================ Custom Mappings ==================
let mapleader = ","
