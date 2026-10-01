#!/usr/bin/env bash
set -euo pipefail
case $(uname -s) in
  Linux)
    sudo apt-get update
    sudo apt-get install --no-install-recommends -y tmux fzf ripgrep autojump shellcheck bash-completion ;;
  Darwin) brew install tmux fzf ripgrep autojump shellcheck bash-completion@2 ;;
  *) echo 'Terminal supports Ubuntu and macOS.' >&2; exit 1 ;;
esac
