#!/usr/bin/env bash

userprofile=$(wslpath "$(wslvar USERPROFILE)")

cp --verbose -r "$HOME/.omnisharp" "$userprofile/"
chmod -R u+x "$HOME/.omnisharp"
