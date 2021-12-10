#!/usr/bin/env bash
# [[file:readme.org::install][install]]
# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::mount][mount]]][mount]]
# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::boilerplate][boilerplate]]][boilerplate]]
DISK=$1

sudo mkdir -p /mnt

if mountpoint -q -- "/mnt"; then
    echo "ERROR: /mnt is a mounted filesystem, aborting"
    exit 1
fi
# boilerplate ends here

# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::mounting][mounting]]][mounting]]
echo "LOG: Mounting tmpfs"
sudo mount -t tmpfs root /mnt

echo "LOG: - Mounting persistent directories"
sudo mkdir -p /mnt/persist /mnt/nix /mnt/boot
sudo mount -o subvol=root,autodefrag,noatime "${DISK}1" /mnt/persist
sudo mount -o subvol=nix,autodefrag,noatime "${DISK}1" /mnt/nix
sudo mount -o subvol=boot,autodefrag,noatime "${DISK}1" /mnt/boot

echo "LOG: - Mounting EFI System Partition"
sudo mkdir -p /mnt/boot/efi
sudo mount "${DISK}2" /mnt/boot/efi
# mounting ends here
# mount ends here

# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::installing][installing]]][installing]]
echo "LOG: Installing NixOS"
sudo nixos-install --flake /etc/nixos#Infini-STICK --no-root-password
# installing ends here
# install ends here
