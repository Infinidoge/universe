#!/usr/bin/env bash

attr="$FLAKEROOT#$HOST"
if [ -x /run/wrappers/bin/sudo ]; then
    export PATH=/run/wrappers/bin:$PATH
    sudo nixos-rebuild --flake "$attr" "${@:1}"
else
    nixos-rebuild --flake "$attr" "${@:1}"
fi
