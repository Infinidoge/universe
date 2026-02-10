{ nixos, ... }:
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
    filesystems.btrfs
    filesystems.encrypted
    hardware.gpu.intel
    shells.xonsh
    shells.zsh

    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "22.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8ptHWTesaUzglq01O8OVqeAGxFhXutUZpkgPpBFqzY root@pluto";

  boot.loader.timeout = 1;

  persist.directories = [
    "/srv"
  ];
}
