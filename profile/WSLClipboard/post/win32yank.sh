#!/usr/bin/env bash
set -euo pipefail
[[ $(uname -r) == *[Mm]icrosoft* ]] || { echo 'WSLClipboard requires WSL.' >&2; exit 1; }
[[ $(uname -m) == x86_64 ]] || { echo 'This win32yank download supports x86_64 only.' >&2; exit 1; }
command -v unzip >/dev/null || { sudo apt-get update; sudo apt-get install --no-install-recommends -y unzip; }
mkdir -p "$HOME/.bin"
if [[ -x $HOME/.bin/win32yank.exe ]]; then exit 0; fi
curl --fail --location --retry 3 https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip -o win32yank.zip
unzip -q win32yank.zip win32yank.exe
install -m 755 win32yank.exe "$HOME/.bin/win32yank.exe"
