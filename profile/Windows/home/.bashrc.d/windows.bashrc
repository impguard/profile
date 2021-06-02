#!/usr/bin/env bash

export USERPROFILE

USERPROFILE=$(wslpath "$(wslvar USERPROFILE 2>/dev/null)")
