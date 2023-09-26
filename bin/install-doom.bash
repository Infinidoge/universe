#!/usr/bin/env bash

if [ ! -d $XDG_CONFIG_HOME/emacs ]; then
  git clone --depth 1 https://github.com/doomemacs/doomemacs $XDG_CONFIG_HOME/emacs
  $XDG_CONFIG_HOME/emacs/bin/doom install "$@"
else
  echo "fatal: $XDG_CONFIG_HOME/emacs already exists!"
fi
