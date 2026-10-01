#!/usr/bin/env bash
# Completion is optional. Support both Homebrew installation prefixes.
for completion in /opt/homebrew/etc/profile.d/bash_completion.sh /usr/local/etc/profile.d/bash_completion.sh; do
  if [[ -r $completion && ${BASH_VERSINFO[0]} -ge 4 ]]; then
    source "$completion"
    break
  fi
done
unset completion
