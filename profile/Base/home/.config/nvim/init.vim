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
set guicursor=                  " Always use block cursor
set nohlsearch                  " Disable highlight search
set noshowmode                  " Don't show the mode
set termguicolors

" Automatically remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Turn on syntax highlighting
syntax enable

" ================ Install plugins =================
call plug#begin('~/.local/share/nvim/plugged')

" Deoplete completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc.vim'

" Typescript
" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'mhartington/nvim-typescript', {'do': './install.sh'}

" Python
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'davidhalter/jedi-vim'

" Go
Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}

" Rust
" Plug 'rust-lang/rust.vim'

" Javascript
" Plug 'pangloss/vim-javascript'
" Plug 'mxw/vim-jsx'
" Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
" Plug 'ternjs/tern_for_vim'

" Terraform
" Plug 'hashivim/vim-terraform'
" Plug 'juliosueiras/vim-terraform-completion'

" File search
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
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
" Useful tabularize function
Plug 'godlygeek/tabular'

" Color scheme
Plug 'lifepillar/vim-solarized8'
" Plug 'morhetz/gruvbox'

call plug#end()

" ================ Common Settings ================
let mapleader = ","

" ================ Deoplete Settings ==============
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Adjust delay to 30 ms
call deoplete#custom#option('auto_complete_delay', 30)

" Silence the  messages in the command line
" such as 'The only match', 'Pattern not found', 'Back at original", etc.
set shortmess+=c

" ================ Jedi-Vim Settings =============
let g:jedi#completions_enabled = 0

" ================ Python Settings ===============
let g:python_host_prog = '/Users/kwu/.pyenv/versions/neovim/bin/python'
let g:python3_host_prog = '/Users/kwu/.pyenv/versions/neovim/bin/python'

" ================ Go Settings ===================
let g:deoplete#sources#go#gocode_binary = '$GOPATH/bin/gocode'

" ================ Tern Settings =================
" let g:tern#command = ["tern"]
" let g:tern#arguments = ["--persistent"]

" ================ Echodoc Settings ==============
let g:echodoc#enable_at_startup = 1
set completeopt-=preview

" ================ fzf Settings ===================
noremap <c-p> :Files<CR>

" ================ NERDTree Settings ==============
let NERDTreeIgnore = ['\.\.$', '\.$', '__pycache__', 'node_modules', '\.git$', '\.pyc$', '.cache', '.DS_Store', '.terraform']
let NERDTreeShowHidden=1
noremap <leader>n :NERDTreeToggle<CR>

" ================ Theme =========================
set background=dark
colorscheme solarized8_flat

" ================ Lightline Colorscheme =========
let g:lightline = {
  \ 'colorscheme': 'solarized',
  \ }

" ================ Indentation ===================
set autoindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" ================ Source ========================

source $HOME/.config/nvim/source/python.vim
