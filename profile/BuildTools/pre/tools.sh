#!/usr/bin/env bash
set -euo pipefail
case $(uname -s) in
  Linux)
    sudo apt-get update
    sudo apt-get install --no-install-recommends -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncurses-dev xz-utils tk-dev libffi-dev liblzma-dev ;;
  Darwin) brew install openssl readline sqlite3 xz zlib tcl-tk ;;
  *) echo 'BuildTools supports Ubuntu and macOS.' >&2; exit 1 ;;
esac
