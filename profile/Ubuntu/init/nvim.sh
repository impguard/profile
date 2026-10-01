#!/usr/bin/env bash
set -euo pipefail
# Use the official stable build: Ubuntu's package can lag behind modern defaults.
version=${NVIM_VERSION:-v0.12.5}
[[ $version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo 'NVIM_VERSION must look like v0.12.5.' >&2; exit 1; }
case $(uname -m) in
  x86_64) archive=nvim-linux-x86_64 ;;
  aarch64|arm64) archive=nvim-linux-arm64 ;;
  *) echo 'Neovim official builds require x86_64 or ARM64.' >&2; exit 1 ;;
esac
destination=$HOME/.local/opt/nvim-$version
if [[ ! -x $destination/bin/nvim ]]; then
  curl --fail --location --retry 3 "https://github.com/neovim/neovim/releases/download/$version/$archive.tar.gz" -o nvim.tar.gz
  tar -xzf nvim.tar.gz
  "./$archive/bin/nvim" --version
  mkdir -p "$HOME/.local/opt"
  [[ ! -e $destination ]] || { echo "Incomplete installation exists: $destination" >&2; exit 1; }
  mv "$archive" "$destination"
fi
mkdir -p "$HOME/.local/bin"
# Never replace an unrelated executable or user wrapper without preserving it.
if [[ -e $HOME/.local/bin/nvim || -L $HOME/.local/bin/nvim ]]; then
  if [[ -L $HOME/.local/bin/nvim && $(readlink "$HOME/.local/bin/nvim") == "$destination/bin/nvim" ]]; then exit 0; fi
  mkdir -p "$HOME/.profile-backups"
  backup=$(mktemp -d "$HOME/.profile-backups/nvim.XXXXXX")
  mv "$HOME/.local/bin/nvim" "$backup/nvim"
  printf 'Backups: %s\n' "$backup"
fi
ln -s "$destination/bin/nvim" "$HOME/.local/bin/nvim"
