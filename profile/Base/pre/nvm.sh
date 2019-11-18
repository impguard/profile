#!/usr/bin/env bash

if [ -d "$HOME/.bin/nvm" ]; then
  echo "nvm already installed"
  exit
fi

mkdir -p "$HOME/.bin/nvm"

export NVM_DIR="$HOME/.bin/nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
