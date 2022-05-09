#!/usr/bin/env bash
# [[file:readme.org::full_install][full_install]]
# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::boilerplate][boilerplate]]][boilerplate]]
DISK=$1

sudo mkdir -p /mnt
# boilerplate ends here

# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::mount_check][mount_check]]][mount_check]]
if mountpoint -q -- "/mnt"; then
    echo "ERROR: /mnt is a mounted filesystem, aborting"
    exit 1
fi
# mount_check ends here

# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::partitioning][partitioning]]][partitioning]]
echo "LOG: Partitioning $DISK"
sudo parted $DISK -- mktable gpt
sudo parted $DISK -s -- mkpart primary btrfs 512MiB 100%
sudo parted $DISK -s -- mkpart ESP fat32 1MiB 512MiB
sudo parted $DISK -s -- set 2 esp on
# partitioning ends here

# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::filesystems][filesystems]]][filesystems]]
echo "LOG: Making filesystems"
echo "- Making btrfs filesystem on ${DISK}1"
sudo mkfs.btrfs "${DISK}1" -L "Infini-STICK" -f
echo "- Making fat32 filesystem on ${DISK}2"
sudo mkfs.fat -F 32 -n boot "${DISK}2"
# filesystems ends here

# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::subvolumes][subvolumes]]][subvolumes]]
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
# subvolumes ends here

# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::mounting][mounting]]][mounting]]
echo "LOG: Mounting tmpfs"
sudo mount -t tmpfs root /mnt

echo "LOG: - Mounting persistent directories"
sudo mkdir -p /mnt/persist /mnt/nix /mnt/boot
sudo mount -o subvol=root,autodefrag,noatime "${DISK}1" /mnt/persist
sudo mount -o subvol=nix,autodefrag,noatime "${DISK}1" /mnt/nix
sudo mount -o subvol=boot,autodefrag,noatime "${DISK}1" /mnt/boot

echo "LOG: - - Mounting persistent subdirectories"
sudo mkdir -p /mnt/home
sudo mount --bind /mnt/persist/home /mnt/home

echo "LOG: - Mounting EFI System Partition"
sudo mkdir -p /mnt/boot/efi
sudo mount "${DISK}2" /mnt/boot/efi
# mounting ends here

# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::installing][installing]]][installing]]
echo "LOG: Installing NixOS"
sudo nixos-install --flake /etc/nixos#Infini-STICK --no-root-password
# installing ends here

# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::full_extra][full_extra]]][full_extra]]
echo "LOG: Cloning configuration"
sudo git clone --no-hardlinks --progress https://gitlab.com/infinidoge/universe.git /mnt/persist/etc/nixos
# full_extra ends here

# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::finishing_setup][finishing_setup]]][finishing_setup]]

# finishing_setup ends here

# [[[[file:/etc/nixos/hosts/Infini-STICK/readme.org::cleanup][cleanup]]][cleanup]]
echo "LOG: Unmounting all"
sudo umount -R /mnt
# cleanup ends here
# full_install ends here
