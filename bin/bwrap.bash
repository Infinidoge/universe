#!/usr/bin/env bash
# Modified from https://git.sr.ht/~fd/nix-configs/tree/19a4ffaa09b8bf65eae2962b1efead86c19ea54f/item/ssh-wrap.sh

DEFAULT_COMMAND=zsh
FALLBACK_COMMAND=bash
SAFEWORD=nonix
NIXDIR=${NIXDIR-$HOME/scratch/nix}

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

if [[ "$SSH_ORIGINAL_COMMAND" == "" ]]; then
  SSH_ORIGINAL_COMMAND=$DEFAULT_COMMAND
fi

if [[ "$SSH_ORIGINAL_COMMAND" == "$SAFEWORD" ]]; then
  exec $FALLBACK_COMMAND
fi

if type bwrap &>/dev/null; then
  if [ -z ${NIXDIR+x} ]; then
    echo "NIXDIR is unset! It needs to be set in the code. Edit this shell file and read the instructions."
    echo "Executing fallback without Bubblewrap…"
    exec $FALLBACK_COMMAND
  fi

  if [ ! -e "$NIXDIR" ]; then
    echo "NIXDIR doesn't point to a valid location! Falling back"
    exec $FALLBACK_COMMAND
  fi

  args=(
    --bind "$NIXDIR" /nix
    # --chdir $HOME
  )

  bind \
    "$HOME"

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
    /homes \
    /lib \
    /lib32 \
    /lib64 \
    /libx32 \
    /media \
    /usr \
    /var

  [[ -f "$HOME/.bwrap-extra.bash" ]] && source "$HOME/.bwrap-extra.bash"

  bwrap "${args[@]}" $FALLBACK_COMMAND -c "
		. ${XDG_STATE_HOME-$HOME/.local/state}/nix/profile/etc/profile.d/nix.sh
		exec ${SSH_ORIGINAL_COMMAND}
	"

  status=$?
  if [[ $status != 0 ]]; then
    echo "bwrap exited uncleanly, falling back"
    exec ${FALLBACK_COMMAND}
  fi
else
  exec ${SSH_ORIGINAL_COMMAND}
fi
