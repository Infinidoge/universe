#!/usr/bin/env bash

if [ -x /run/wrappers/bin/sudo ]; then
    export PATH=/run/wrappers/bin:$PATH
fi
nix-collect-garbage "${@}"
sudo nix-collect-garbage "${@}"
