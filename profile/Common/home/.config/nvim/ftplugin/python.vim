syntax sync fromstart

let b:coc_root_patterns = ['.git', '.python-version', 'venv', '.venv', 'Pipfile']

if !empty($PYENV_VIRTUAL_ENV)
  call coc#config('python', {
  \   'pythonPath': $PYENV_VIRTUAL_ENV . '/bin/python'
  \ })
endif

autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
