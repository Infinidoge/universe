#!/usr/bin/env bash
DISK=$1

echo "LOG: Partitioning $DISK"
sudo parted $DISK -- mktable gpt
sudo parted $DISK -s -- mkpart primary btrfs 512MiB 100%
sudo parted $DISK -s -- mkpart ESP fat32 1MiB 512MiB
sudo parted $DISK -s -- set 2 esp on

echo "LOG: Making filesystems"
echo "- Making btrfs filesystem on ${DISK}1"
sudo mkfs.btrfs "${DISK}1" -L "Infini-STICK" -f
echo "- Making fat32 filesystem on ${DISK}2"
sudo mkfs.fat -F 32 -n boot "${DISK}2"

sudo mkdir -p /mnt

echo "LOG: Making subvolumes on ${DISK}1"
sudo mount "${DISK}1" /mnt
sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/root/home
sudo mkdir -p /mnt/root/etc
sudo btrfs subvolume create /mnt/root/etc/nixos
sudo btrfs subvolume create /mnt/boot
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/nix/store
sudo umount /mnt

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

echo "LOG: Cloning configuration"
sudo git clone --no-hardlinks --progress /etc/nixos /mnt/persist/etc/nixos

echo "LOG: Installing NixOS"
sudo nixos-install --flake /mnt/persist/etc/nixos#Infini-STICK --no-root-password

echo "LOG: Unmounting all"
sudo umount -R /mnt
