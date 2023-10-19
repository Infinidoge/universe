#!/usr/bin/env bash
# [[file:readme.org::install_extras][install_extras]]
# [[file:readme.org::install_extras][install_extra]]
echo "LOG: Cloning configuration"
sudo chown -R infinidoge /mnt/persist/etc/nixos /mnt/persist/etc/nixos-private

git clone --no-hardlinks --progress ssh://git@github.com/infinidoge/universe.git /mnt/persist/etc/nixos
git clone --no-hardlinks --progress ssh://git@github.com/infinidoge/universe-private.git /mnt/persist/etc/nixos-private

echo "LOG: Installing Doom Emacs"
git clone --no-hardlinks --progress --depth 1 https://github.com/doomemacs/doomemacs /mnt/persist/home/infinidoge/.config/emacs
HOME=/mnt/persist/home/infinidoge /mnt/persist/home/infinidoge/.config/emacs/bin/doom install --no-config --force
# install_extra ends here
# install_extras ends here
