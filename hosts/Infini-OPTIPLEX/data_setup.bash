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
# data_setup ends here
