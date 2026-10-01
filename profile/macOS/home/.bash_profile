#!/usr/bin/env bash

for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [[ -x $brew_path ]]; then
    eval "$("$brew_path" shellenv)"
    break
  fi
done
unset brew_path

# shellcheck disable=SC1090
source "$HOME/.bashrc"
