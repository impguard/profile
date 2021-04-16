#!/usr/bin/env bash

if [ -d "$HOME/.bin/pyenv" ]; then
  echo "pyenv already installed"
  exit
fi

git clone https://github.com/pyenv/pyenv.git "$HOME/.bin/pyenv"
git clone https://github.com/pyenv/pyenv-virtualenv.git \
  "$HOME/.bin/pyenv/plugins/pyenv-virtualenv"
