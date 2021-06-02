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
set noswapfile                  " Disable swap files
set termguicolors

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

" ================ Install plugins =================
call plug#begin('~/.local/share/nvim/plugged')

" Intellisense Egngine
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Yaml
Plug 'stephpy/vim-yaml'

" Javascript
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

" Jinja2
Plug 'glench/vim-jinja2-syntax'

" File search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" NERD Tree
Plug 'scrooloose/nerdtree'

" Status line
Plug 'itchyny/lightline.vim'

" Useful tabularize function
Plug 'godlygeek/tabular'

" Color scheme
Plug 'lifepillar/vim-solarized8'

call plug#end()

" ================ Common Settings ================
let mapleader = ","

" Recognize Jenkinsfiles
au BufNewFile,BufRead Jenkinsfile setf groovy
au BufNewFile,BufRead *.Jenkinsfile setf groovy

" ================ fzf Settings ===================
noremap <c-p> :Files<CR>

" ================ NERDTree Settings ==============
let NERDTreeIgnore = ['\.\.$', '\.$', '__pycache__', 'node_modules', '\.git$', '\.pyc$', '.cache', '.DS_Store', '.terraform']
let NERDTreeShowHidden=1
noremap <leader>n :NERDTreeToggle<CR>
autocmd FileType nerdtree setlocal signcolumn=no

" ================ CoC Settings ===================

"  To enable highlight current symbol on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2
set signcolumn=yes

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Force enter to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use tab and shift tab to navigate completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Format buffer
nmap <leader>gf <Plug>(coc-format)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" List Coc Commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" ================ Theme =========================
set background=dark
colorscheme solarized8_high

" ================ Lightline Colorscheme =========
let g:lightline = {
  \ 'colorscheme': 'solarized',
\ }

" ================ Indentation ===================
set autoindent
set breakindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" ================ Source ========================

source $HOME/.config/nvim/source/python.vim
