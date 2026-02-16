{ lib, nixos, ... }:
{
  imports = with nixos; [
    base
    backups
    borg
    common
    email
    extra
    grub
    home-manager
    kmscon
    locale
    man
    networking
    nginx
    nix
    options
    persist
    rsyncnet
    secrets
    ssh
    state-version
    tailscale
    virtualisation
    filesystems.btrfs
    filesystems.encrypted
    filesystems.zfs
    locations.purdue
    shells.xonsh
    shells.zsh

    ./hardware-configuration.nix
    ./disks.nix
  ];

  system.stateVersion = "25.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBanlhzmtBf5stg2yYdxqb9FzFZmum/rlWod/akWQI3c root@hestia";

  boot.loader.timeout = 1;
}
