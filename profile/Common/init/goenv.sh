#!/usr/bin/env bash

if [ -d "$HOME/.bin/goenv" ]; then
  echo "goenv already installed"
  exit
fi

git clone https://github.com/syndbg/goenv.git "$HOME/.bin/goenv"
