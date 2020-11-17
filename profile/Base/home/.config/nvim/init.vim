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

" Disable ALE LSP since Coc Manages it
let g:ale_disable_lsp = 1

" ================ Install plugins =================
call plug#begin('~/.local/share/nvim/plugged')

" Intellisense Egngine
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Asynchronous Linting Engine
Plug 'w0rp/ale'

" Javascript
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

" File search
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
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

" Copied defaults from: https://github.com/neoclide/coc.nvim

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

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" ================ Theme =========================
set background=dark
colorscheme solarized8_high

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

" Archive of old plugins

" Deoplete completion
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'Shougo/echodoc.vim'

" Typescript
" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'mhartington/nvim-typescript', {'do': './install.sh'}

" Python
" Plug 'deoplete-plugins/deoplete-jedi'
" Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'davidhalter/jedi-vim'
" Plug 'fisadev/vim-isort'

" Go
" Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Rust
" Plug 'rust-lang/rust.vim'

" Javascript
" Plug 'yuezk/vim-js'
" Plug 'maxmellon/vim-jsx-pretty'
"
" Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
" Plug 'ternjs/tern_for_vim'

" Terraform
" Plug 'hashivim/vim-terraform'
" Plug 'juliosueiras/vim-terraform-completion'

" File search
" Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
" Plug 'junegunn/fzf.vim'
" NERD Tree
" Plug 'scrooloose/nerdtree'
" Sublime multiple cursors
" Plug 'terryma/vim-multiple-cursors'
" Common Unix commands
" Plug 'tpope/vim-eunuch'
" Editor config support
" Plug 'editorconfig/editorconfig-vim'

" ================ Deoplete Settings ==============
" let g:deoplete#enable_at_startup = 1
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
"
" " Adjust delay to 30 ms
" call deoplete#custom#option('auto_complete_delay', 30)
"
" " Silence the  messages in the command line
" " such as 'The only match', 'Pattern not found', 'Back at original", etc.
" set shortmess+=c
"
" " Support for terraform
" let g:deoplete#omni_patterns = {}
" let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'
"
" " Disable deoplete when in multi cursor mode
" function! Multiple_cursors_before()
"   let b:deoplete_disable_auto_complete = 1
" endfunction
"
" function! Multiple_cursors_after()
"   let b:deoplete_disable_auto_complete = 0
" endfunction

" ================ Jedi-Vim Settings =============
" let g:jedi#completions_enabled = 0
" let g:jedi#usages_command = "<leader>u"

" ================ Python Settings ===============
" let g:python_host_prog = '/Users/kwu/.pyenv/versions/neovim/bin/python'
" let g:python3_host_prog = '/Users/kwu/.pyenv/versions/neovim/bin/python'

" ================ Go Settings ===================
" let g:deoplete#sources#go#gocode_binary = '$GOPATH/bin/gocode'
"
" let g:go_highlight_build_constraints = 1
" let g:go_highlight_extra_types = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_functions = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_operators = 1
" let g:go_highlight_structs = 1
" let g:go_highlight_types = 1
" " let g:go_auto_sameids = 1
" let g:go_auto_type_info = 1
" let g:go_fmt_command = "goimports"
" let g:go_addtags_transform = "snakecase"
" let g:go_updatetime = 1

" ================ Tern Settings =================
" let g:tern#command = ["tern"]
" let g:tern#arguments = ["--persistent"]

" ================ Echodoc Settings ==============
" let g:echodoc#enable_at_startup = 1
" set completeopt-=preview
