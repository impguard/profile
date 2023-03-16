#!/usr/bin/env bash

curl -L https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip -o win32yank-64.zip

unzip win32yank-64.zip
chmod u+x win32yank.exe
cp win32yank.exe "$HOME/.bin"
