#!/usr/bin/env bash

if [ -d /usr/local/etc/bash_completion.d ]; then
  source /usr/local/etc/bash_completion.d/git-completion.bash
  source /usr/local/etc/bash_completion.d/git-prompt.sh
fi
