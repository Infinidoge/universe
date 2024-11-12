#!/usr/bin/env bash
# [[file:readme.org::install_extras][install_extras]]
# [[file:readme.org::install_extras][install_extra]]
echo "LOG: Cloning configuration"
sudo chown -R infinidoge /mnt/persist/etc/nixos /mnt/persist/etc/nixos-private

git clone --no-hardlinks --progress ssh://git@github.com/infinidoge/universe.git /mnt/persist/etc/nixos
git clone --no-hardlinks --progress ssh://git@github.com/infinidoge/universe-private.git /mnt/persist/etc/nixos-private
# install_extra ends here
# install_extras ends here
