setlocal autoindent
setlocal tabstop=2
setlocal shiftwidth=2
setlocal noexpandtab

autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
