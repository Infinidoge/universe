{ nixos, ... }:
{
  imports = with nixos; [
    base
    backups
    borg
    common
    email
    # graphical
    grub
    home-manager
    kmscon
    locale
    man
    networking
    nix
    node
    options
    persist
    rsyncnet
    secrets
    ssh
    state-version
    tailscale
    filesystems.btrfs
    filesystems.encrypted
    # filesystems.zfs
    # hardware.audio
    # hardware.bluetooth
    # hardware.wifi
    # hardware.yubikey
    # hardware.gpu.intel
    # hardware.gpu.nvidia
    # hardware.gpu.amd
    shells.xonsh
    shells.zsh

    ./hardware-configuration.nix
    ./disks.nix
  ];

  system.stateVersion = "";

  age.rekey.hostPubkey = "";

  info.model = "";
}
