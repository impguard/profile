#!/usr/bin/env bash

rm -rf "$HOME/.bin/pyenv"

git clone https://github.com/pyenv/pyenv.git "$HOME/.bin/pyenv"
git clone https://github.com/pyenv/pyenv-virtualenv.git \
  "$HOME/.bin/pyenv/plugins/pyenv-virtualenv"
