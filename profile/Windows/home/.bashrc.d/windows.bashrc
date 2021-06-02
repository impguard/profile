#!/usr/bin/env bash

export USERPROFILE

USERPROFILE=$(wslpath "$(wslvar USERPROFILE 2>/dev/null)")

if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval "$(ssh-agent -s)" 1>/dev/null 2>&1
  ssh-add ~/.ssh/github 1>/dev/null 2>&1
fi
