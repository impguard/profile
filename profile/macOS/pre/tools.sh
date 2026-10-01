#!/usr/bin/env bash
set -euo pipefail
command -v brew >/dev/null || { echo 'Install Homebrew first: https://brew.sh' >&2; exit 1; }
brew install bash curl git neovim mise
