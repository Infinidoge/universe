#!/usr/bin/env bash
# [[file:readme.org::install][install]]
# [[file:readme.org::mount][mount]]
# [[file:readme.org::mount][boilerplate]]
DISK=$1
PART=$DISK$2

sudo mkdir -p /mnt
# boilerplate ends here

# [[file:readme.org::mount][mount_check]]
if mountpoint -q -- "/mnt"; then
    echo "ERROR: /mnt is a mounted filesystem, aborting"
    exit 1
fi
# mount_check ends here

# [[file:readme.org::mounting][mounting]]
echo "LOG: Mounting tmpfs"
sudo mount -t tmpfs root /mnt

mntopts="autodefrag,noatime,compress=zstd:1"

echo "LOG: - Mounting persistent directories"
sudo mkdir -p /mnt/persist /mnt/nix /mnt/boot /mnt/etc/ssh
sudo mount -o subvol=root,$mntopts "${PART}2" /mnt/persist
sudo mount -o subvol=nix,$mntopts "${PART}2" /mnt/nix
sudo mount -o subvol=boot,$mntopts "${PART}2" /mnt/boot
sudo mount -o subvol=root/etc/ssh,$mntopts "${PART}2" /mnt/etc/ssh

echo "LOG: - - Mounting persistent subdirectories"
sudo mkdir -p /mnt/home
sudo mount --bind /mnt/persist/home /mnt/home

echo "LOG: - Mounting EFI System Partition"
sudo mkdir -p /mnt/boot/efi
sudo mount "${PART}1" /mnt/boot/efi
# mounting ends here
# mount ends here

# [[file:readme.org::installing][installing]]
echo "LOG: Installing NixOS"
sudo nixos-install --flake /etc/nixos#Infini-OPTIPLEX --no-root-password
# installing ends here

# [[file:readme.org::install_extra][install_extra]]
echo "LOG: Cloning configuration"
sudo chown -R infinidoge /mnt/persist/etc/nixos /mnt/persist/etc/nixos-private

git clone --no-hardlinks --progress ssh://git@github.com/infinidoge/universe.git /mnt/persist/etc/nixos
git clone --no-hardlinks --progress ssh://git@github.com/infinidoge/universe-private.git /mnt/persist/etc/nixos-private
# install_extra ends here

# [[file:readme.org::cleanup][cleanup]]
echo "LOG: Unmounting all"
sudo umount -R /mnt
# cleanup ends here
# install ends here
