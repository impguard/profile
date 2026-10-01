#!/usr/bin/env bash
set -euo pipefail
[[ $(uname -s) == Darwin ]] || { echo 'Hammerspoon requires macOS.' >&2; exit 1; }
brew install --cask hammerspoon
