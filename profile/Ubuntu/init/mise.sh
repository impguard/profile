#!/usr/bin/env bash
set -euo pipefail
if command -v mise >/dev/null 2>&1 || [[ -x $HOME/.local/bin/mise ]]; then
  echo 'mise already installed'
  exit 0
fi
curl --fail --location --retry 3 https://mise.jdx.dev/install.sh -o mise-install.sh
MISE_INSTALL_PATH="$HOME/.local/bin/mise" sh mise-install.sh
"$HOME/.local/bin/mise" --version
