#!/usr/bin/env bash
# [[file:readme.org::preparation][preparation]]
# [[[[file:/etc/nixos/hosts/Infini-DESKTOP/readme.org::boilerplate][boilerplate]]][boilerplate]]
DISK=$1
PARTITION_PREFIX="p"

sudo mkdir -p /mnt
# boilerplate ends here



# [[[[file:/etc/nixos/hosts/Infini-DESKTOP/readme.org::partitioning][partitioning]]][partitioning]]
echo "LOG: Partitioning $DISK"
sudo parted $DISK -- mktable gpt
sudo parted $DISK -s -- mkpart ESP fat32 1MiB 512MiB
sudo parted $DISK -s -- mkpart primary btrfs 512MiB -48GiB
sudo parted $DISK -s -- mkpart primary linux-swap -48GiB 100%
sudo parted $DISK -s -- set 1 esp on
# partitioning ends here

# [[[[file:/etc/nixos/hosts/Infini-DESKTOP/readme.org::filesystems][filesystems]]][filesystems]]
echo "LOG: Making filesystems"
echo "- Making fat32 filesystem on ${DISK}${PARTITION_PREFIX}1"
sudo mkfs.fat -F 32 -n boot "${DISK}${PARTITION_PREFIX}1"
echo "- Making btrfs filesystem on ${DISK}${PARTITION_PREFIX}2"
sudo mkfs.btrfs "${DISK}${PARTITION_PREFIX}2" -L "Infini-DESKTOP" -f
echo "- Making swap space on ${DISK}${PARTITION_PREFIX}3"
sudo mkswap -L swap "${DISK}${PARTITION_PREFIX}3"
# filesystems ends here

# [[[[file:/etc/nixos/hosts/Infini-DESKTOP/readme.org::subvolumes][subvolumes]]][subvolumes]]
echo "LOG: Making subvolumes on ${DISK}${PARTITION_PREFIX}2"
sudo mount "${DISK}${PARTITION_PREFIX}2" /mnt
sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/root/home
sudo mkdir -p /mnt/root/etc
sudo btrfs subvolume create /mnt/root/etc/nixos
sudo btrfs subvolume create /mnt/boot
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/nix/store
sudo umount /mnt
# subvolumes ends here
# preparation ends here