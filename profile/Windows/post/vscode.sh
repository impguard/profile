#!/usr/bin/env bash

userprofile=$(wslpath "$(wslvar USERPROFILE)")

echo cp -a "$HOME/.omnisharp" "$userprofile/"
