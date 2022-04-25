#!/usr/bin/env bash

attr="$FLAKEROOT#$HOST"
if [ -x /run/wrappers/bin/sudo ]; then
    export PATH=/run/wrappers/bin:$PATH
fi
nixos-rebuild --flake "$attr" --use-remote-sudo "${@:-switch}"
