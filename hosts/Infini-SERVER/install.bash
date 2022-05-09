#!/usr/bin/env bash
# [[file:readme.org::install][install]]
# [[[[file:/etc/nixos/hosts/Infini-SERVER/readme.org::mount][mount]]][mount]]
# [[[[file:/etc/nixos/hosts/Infini-SERVER/readme.org::boilerplate][boilerplate]]][boilerplate]]
DISK=$1
PARTITION_PREFIX=$2

sudo mkdir -p /mnt
# boilerplate ends here

# [[[[file:/etc/nixos/hosts/Infini-SERVER/readme.org::mount_check][mount_check]]][mount_check]]
if mountpoint -q -- "/mnt"; then
    echo "ERROR: /mnt is a mounted filesystem, aborting"
    exit 1
fi
# mount_check ends here

# [[[[file:/etc/nixos/hosts/Infini-SERVER/readme.org::mounting][mounting]]][mounting]]
echo "LOG: Mounting tmpfs"
sudo mount -t tmpfs root /mnt

echo "LOG: - Mounting persistent directories"
sudo mkdir -p /mnt/persist /mnt/nix /mnt/boot
sudo mount -o subvol=root,autodefrag,noatime "${DISK}${PARTITION_PREFIX}2" /mnt/persist
sudo mount -o subvol=nix,autodefrag,noatime "${DISK}${PARTITION_PREFIX}2" /mnt/nix
sudo mount -o subvol=boot,autodefrag,noatime "${DISK}${PARTITION_PREFIX}2" /mnt/boot

echo "LOG: - - Mounting persistent subdirectories"
sudo mkdir -p /mnt/home
sudo mount --bind /mnt/persist/home /mnt/home

echo "LOG: - Mounting EFI System Partition"
sudo mkdir -p /mnt/boot/efi
sudo mount "${DISK}${PARTITION_PREFIX}1" /mnt/boot/efi
# mounting ends here
# mount ends here

# [[[[file:/etc/nixos/hosts/Infini-SERVER/readme.org::installing][installing]]][installing]]
echo "LOG: Installing NixOS"
sudo nixos-install --flake /etc/nixos#Infini-SERVER --no-root-password
# installing ends here

# [[[[file:/etc/nixos/hosts/Infini-SERVER/readme.org::install_extra][install_extra]]][install_extra]]
echo "LOG: Cloning configuration"
sudo chown -R infinidoge /mnt/persist/etc/nixos
git clone --no-hardlinks --progress https://gitlab.com/infinidoge/universe.git /mnt/persist/etc/nixos

echo "LOG: Installing Doom Emacs"
git clone --no-hardlinks --progress --depth 1 https://github.com/hlissner/doom-emacs /mnt/persist/home/infinidoge/.config/emacs
HOME=/mnt/persist/home/infinidoge /mnt/persist/home/infinidoge/.config/emacs/bin/doom -y install --no-config
# install_extra ends here

# [[[[file:/etc/nixos/hosts/Infini-SERVER/readme.org::cleanup][cleanup]]][cleanup]]
echo "LOG: Unmounting all"
sudo umount -R /mnt
# cleanup ends here
# install ends here
