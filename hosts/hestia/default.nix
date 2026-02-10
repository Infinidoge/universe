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

  modules.hardware.form.server = true;
  modules.backups.enable = false; # hestia is a backup target
  boot.loader.timeout = 1;

  swapDevices = lib.mkForce [
    {
      device = "/dev/disk/by-uuid/a41fad08-24ee-421b-a2c5-59571bdc0c80";
    }
  ];
}
