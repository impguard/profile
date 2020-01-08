#!/usr/bin/env bash

if [ -d "$HOME/.bin/jenv" ]; then
  echo "jenv already installed"
  exit
fi

git clone https://github.com/gcuisinier/jenv.git "$HOME/.bin/jenv"
