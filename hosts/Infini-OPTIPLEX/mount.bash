#!/usr/bin/env bash
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

# [[file:readme.org::mount][mounting]]
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
