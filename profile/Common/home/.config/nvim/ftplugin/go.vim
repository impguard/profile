" Set indentation to 2 space tabs
setlocal autoindent
setlocal tabstop=2
setlocal shiftwidth=2
setlocal noexpandtab

" Automatically organize import on save
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
