syntax sync fromstart

let b:coc_root_patterns = ['.git', '.python-version', 'venv', '.venv', 'Pipfile']

let b:ale_fixers = ['isort', 'black']
let b:ale_fix_on_save = 0

let b:ale_python_black_options="--line-length 120"

let b:ale_linters = ['mypy', 'flake8']
let b:ale_python_flake8_auto_pipenv=1
let b:ale_python_mypy_auto_pipenv=1
let b:ale_python_flake8_options="--max-line-length 120"

if !empty($PYENV_VIRTUAL_ENV)
  call coc#config('python', {
  \   'pythonPath': $PYENV_VIRTUAL_ENV . '/bin/python'
  \ })
endif
