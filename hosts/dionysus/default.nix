{ nixos, ... }:
{
  imports = with nixos; [
    base
    backups
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
    nginx
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
    hardware.audio
    hardware.gpu.intel
    hardware.receipt-printer
    hardware.wifi
    locations.purdue
    shells.xonsh
    shells.zsh

    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "23.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG8fY684SPKeOUsJqaV6LJwwztWxztaU9nAHPBxBtyU root@dionysus";

  boot.loader.timeout = 1;

  services.printing = {
    enable = true;
    listenAddresses = [
      "localhost:631"
      "100.101.102.18:631"
      "dionysus:631"
    ];
    allowFrom = [ "all" ];
    defaultShared = true;
    openFirewall = true;
  };
}
