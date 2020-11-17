let b:coc_root_patterns = ['.git', '.python-version', 'venv', '.venv', 'Pipfile']

let b:ale_fixers = ['isort', 'black']
let b:ale_fix_on_save = 1

let b:ale_linters = ['mypy', 'flake8']
let g:ale_python_flake8_auto_pipenv=1
let g:ale_python_mypy_auto_pipenv=1
let g:ale_python_flake8_options="--max-line-length 88"
