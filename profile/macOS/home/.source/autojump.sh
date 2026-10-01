#!/usr/bin/env bash

for autojump in /opt/homebrew/etc/profile.d/autojump.sh /usr/local/etc/profile.d/autojump.sh; do
  if [[ -r $autojump ]]; then source "$autojump"; break; fi
done
unset autojump
