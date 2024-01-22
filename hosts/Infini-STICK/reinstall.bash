#!/usr/bin/env bash
# [[file:readme.org::reinstall][reinstall]]
# [[file:readme.org::mount][mount]]
# [[file:readme.org::mount][boilerplate]]
DISK=$1

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

echo "LOG: - Mounting persistent directories"
sudo mkdir -p /mnt/persist /mnt/nix /mnt/boot
sudo mount -o subvol=root,autodefrag,noatime "${DISK}3" /mnt/persist
sudo mount -o subvol=nix,autodefrag,noatime "${DISK}3" /mnt/nix
sudo mount -o subvol=boot,autodefrag,noatime "${DISK}3" /mnt/boot

echo "LOG: - - Mounting persistent subdirectories"
sudo mkdir -p /mnt/home /mnt/etc/ssh
sudo mount --bind /mnt/persist/home /mnt/home
sudo mount --bind /mnt/persist/etc/ssh /mnt/etc/ssh

echo "LOG: - Mounting EFI System Partition"
sudo mkdir -p /mnt/boot/efi
sudo mount "${DISK}4" /mnt/boot/efi
# mounting ends here
# mount ends here

# [[file:readme.org::reinstall][installing]]
echo "LOG: Installing NixOS"
sudo nixos-install --flake /etc/nixos#Infini-STICK --no-root-password
# installing ends here

# [[file:readme.org::reinstall_extra][reinstall_extra]]

# reinstall_extra ends here

# [[file:readme.org::reinstall][finishing_setup]]

# finishing_setup ends here

# [[file:readme.org::reinstall][cleanup]]
echo "LOG: Unmounting all"
sudo umount -R /mnt
# cleanup ends here
# reinstall ends here
