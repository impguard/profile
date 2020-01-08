#!/usr/bin/env bash

# shellcheck disable=SC1090
PATH="$HOME/.bin/jenv/bin:$PATH"

eval "$(jenv init -)"

jenv enable-plugin export
jenv enable-plugin maven
