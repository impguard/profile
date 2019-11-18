#!/usr/bin/env bash

if [ -d "$HOME/.bin/nodenv" ]; then
  echo "nodenv already installed"
  exit
fi

# Install nodenv and upgrade extensions
git clone https://github.com/nodenv/nodenv.git "$HOME/.bin/nodenv"
cd ~/.bin/nodenv && src/configure && make -C src

# Install node build plugin for nodenv
git clone https://github.com/nodenv/node-build.git "$HOME/.bin/nodenv/plugins/node-build"
