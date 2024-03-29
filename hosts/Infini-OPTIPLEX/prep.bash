#!/usr/bin/env bash
# [[file:readme.org::preparation][preparation]]
# [[file:readme.org::boilerplate][boilerplate]]
DISK=$1
PART=$DISK$2

sudo mkdir -p /mnt
# boilerplate ends here

# [[file:readme.org::mount_check][mount_check]]
if mountpoint -q -- "/mnt"; then
    echo "ERROR: /mnt is a mounted filesystem, aborting"
    exit 1
fi
# mount_check ends here

# [[file:readme.org::partitioning][partitioning]]
echo "LOG: Partitioning $DISK"
sudo parted $DISK -- mktable gpt
sudo parted $DISK -s -- mkpart ESP fat32 1MiB 512MiB
sudo parted $DISK -s -- mkpart primary btrfs 512MiB -12GiB
sudo parted $DISK -s -- mkpart primary linux-swap -12GiB 100%
sudo parted $DISK -s -- set 1 esp on
# partitioning ends here

# [[file:readme.org::filesystems][filesystems]]
echo "LOG: Making filesystems"
echo "- Making fat32 filesystem on ${PART}1"
sudo mkfs.fat -F 32 -n boot "${PART}1"
echo "- Making btrfs filesystem on ${PART}2"
sudo mkfs.btrfs "${PART}2" -L "Infini-OPTIPLEX" -f
echo "- Making swap space on ${PART}3"
sudo mkswap -L swap "${PART}3"
# filesystems ends here

# [[file:readme.org::subvolumes][subvolumes]]
echo "LOG: Making subvolumes on ${PART}2"
sudo mount "${PART}2" /mnt
sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/root/home
sudo mkdir -p /mnt/root/etc
sudo btrfs subvolume create /mnt/root/etc/nixos
sudo btrfs subvolume create /mnt/root/etc/nixos-private
sudo btrfs subvolume create /mnt/root/etc/ssh
sudo btrfs subvolume create /mnt/boot
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/nix/store
sudo umount /mnt
# subvolumes ends here
# preparation ends here
