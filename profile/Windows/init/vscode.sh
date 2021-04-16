#!/usr/bin/env bash

userprofile=$(wslpath "$(wslvar USERPROFILE)")

cp --verbose --dereference --recursive "$HOME/.omnisharp" "$userprofile/"
chmod -R u+x "$HOME/.omnisharp"
