{ nixos, ... }:
{
  imports = with nixos; [
    base
    backups
    borg
    common
    email
    graphical
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
    qtile
    rsyncnet
    secrets
    ssh
    state-version
    tailscale
    filesystems.btrfs
    filesystems.encrypted
    hardware.audio
    hardware.gpu.intel
    shells.xonsh
    shells.zsh

    ./hardware-configuration.nix
    ./disks.nix
  ];

  system.stateVersion = "26.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAKvGPh6rPAkfIcXOBGGWMiChCVfbsstJBKeRJuAIopY root@bacchus";

  info.model = "OptiPlex 5040";
}
