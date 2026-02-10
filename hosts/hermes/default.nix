{ nixos, ... }:
{
  imports = with nixos; [
    base
    borg
    common
    email
    extra
    graphical
    grub
    home-manager
    kmscon
    locale
    man
    networking
    nix
    options
    persist
    qtile
    rsyncnet
    secrets
    ssh
    state-version
    tailscale
    filesystems.btrfs
    filesystems.encrypted
    filesystems.windows
    filesystems.zfs
    hardware.audio
    hardware.bluetooth
    hardware.wifi
    hardware.yubikey
    hardware.gpu.intel
    hardware.gpu.amd
    hardware.gpu.nvidia
    programs.android
    shells.xonsh
    shells.zsh

    ./hardware-configuration.nix
    ./disks.nix
  ];

  system.stateVersion = "24.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0fWuozCHyPrkFKPcnqX1MyUAgnn2fJEpDSoD7bhDA4 root@hermes";
}
