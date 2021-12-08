#!/usr/bin/env bash
DISK=$1

sudo parted $DISK -- mktable gpt
sudo parted $DISK -- mkpart primary btrfs 512MiB 100%
sudo parted $DISK -- mkpart ESP fat32 1MiB 512MiB
sudo parted $DISK -- set 2 esp on

sudo mkfs.btrfs "${DISK}1" -L "Infini-STICK"
sudo mkfs.fat -F 32 -n boot "${DISK}2"

sudo mount "${DISK}1" /mnt
sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/root/home
sudo mkdir -p /mnt/root/etc
sudo btrfs subvolume create /mnt/root/etc/nixos
sudo btrfs subvolume create /mnt/boot
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/nix/store


sudo mount -t tmpfs root /mnt

sudo mkdir -p /mnt/persist /mnt/nix /mnt/boot
sudo mount -o subvol=root,autodefrag,noatime "${DISK}1" /mnt/persist
sudo mount -o subvol=nix,autodefrag,noatime "${DISK}1" /mnt/nix
sudo mount -o subvol=boot,autodefrag,noatime "${DISK}1" /mnt/boot

sudo mkdir -p /mnt/boot/efi
sudo mount "${DISK}2" /mnt/boot/efi
