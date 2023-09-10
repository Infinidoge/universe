#!/usr/bin/env bash

if [ -z ${NIXDIR+x} ]; then 
    echo "NIXDIR is unset! It needs to be set in the code. Edit this shell file and read the instructions."
    echo "Executing bash without Bubblewrap…"
    exec bash
fi

if [ ! -e $NIXDIR ]; then
    echo "NIXDIR doesn't point to a valid location! Falling back to Bash"
    exec bash
fi

_bind() {
    _bind_arg=$1
    shift
    for _path in "$@"; do
        args+=("$_bind_arg" "$_path" "$_path")
    done
}

bind() {
    _bind --bind-try "$@"
}

robind() {
    _bind --ro-bind-try "$@"
}

devbind() {
    _bind --dev-bind-try "$@"
}

args=(
    --bind $NIXDIR /nix
    --chdir $HOME
)

bind \
    $HOME

devbind \
    /dev \
    /proc \
    /tmp \
    /run \
    /u \
    /p \
    /bin \
    /boot \
    /etc \
    /home \
    /lib \
    /lib32 \
    /lib64 \
    /libx32 \
    /media \
    /usr \
    /var

exec bwrap "${args[@]}" "$@"
