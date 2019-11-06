#!/usr/bin/env bash

# shellcheck disable=SC1090
PATH="$HOME/.bin/pyenv/bin/pyenv":$PATH

SOURCE_DIR="$HOME/.config/nvim/source"
SOURCE_FILENAME="$SOURCE_DIR/python.vim"

mkdir -p "$SOURCE_DIR"
touch "$SOURCE_FILENAME"

pyenv install -s 2.7.14
pyenv install -s 3.7.4

pyenv virtualenv 2.7.14 neovim2
pyenv virtualenv 3.7.4 neovim3

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv activate neovim2
pip install pynvim

echo "let g:python_host_prog = '$(pyenv which python)'" > "$SOURCE_FILENAME"

pyenv activate neovim3
pip install neovim

echo "let g:python3_host_prog = '$(pyenv which python)'" >> "$SOURCE_FILENAME"

nvim +'PlugUpdate --sync' +'UpdateRemotePlugins' +qa
