{ lib, nixos, ... }:
{
  imports = with nixos; [
    base
    backups
    borg
    email
    extra
    home-manager
    kmscon
    locale
    man
    networking
    nginx
    nix
    node
    options
    persist
    rsyncnet
    secrets
    ssh
    state-version
    systemd-boot
    tailscale
    virtualisation
    xen-dom0
    filesystems.btrfs
    filesystems.encrypted
    filesystems.zfs
    locations.purdue

    ./hardware-configuration.nix
    ./disks.nix
  ];

  system.stateVersion = "26.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBQ4xLP0SoMHYp3gIiSU8BZDuMT+itxj8qjkYofniOv root@hestia";

  boot.loader.timeout = 1;

  nix.distributedBuilds = false;
}
