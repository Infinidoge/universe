#!/usr/bin/env bash
# [[file:readme.org::data_setup][data_setup]]
# [[file:readme.org::data_setup][boilerplate]]
DISK=$1
PART=$DISK$2

sudo mkdir -p /mnt
# boilerplate ends here

# [[file:readme.org::data_setup][mount_check]]
if mountpoint -q -- "/mnt"; then
    echo "ERROR: /mnt is a mounted filesystem, aborting"
    exit 1
fi
# mount_check ends here

# [[file:readme.org::data_partitioning][data_partitioning]]
echo "LOG: Partitioning $DISK for data storage"
sudo parted $DISK -- mktable gpt
sudo parted $DISK -s -- mkpart primary btrfs 0% 100%
# data_partitioning ends here

# [[file:readme.org::data_filesystems][data_filesystems]]
echo "LOG: Making data filesystems"
echo "- Making btrfa filesystem on ${PART}1"
sudo mkfs.btrfs "${PART}1" --csum xxhash -L "data" -f
# data_filesystems ends here

# [[file:readme.org::data_subvolumes][data_subvolumes]]
echo "LOG: Making data subvolumes on ${PART}1"
sudo mount "${PART}1" /mnt
sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/root/srv
sudo btrfs subvolume create /mnt/root/srv/jellyfin
# data_subvolumes ends here
# data_setup ends here
