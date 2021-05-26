#!/usr/bin/env bash

export USERPROFILE

USERPROFILE=$(wslpath "$(wslvar USERPROFILE)")

if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval "$(ssh-agent -s)"
  ssh-add
fi
