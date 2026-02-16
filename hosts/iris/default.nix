{ nixos, ... }:
{
  imports = with nixos; [
    base
    backups
    borg
    common
    email
    grub
    home-manager
    locale
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
    shells.xonsh
    shells.zsh

    ./hardware-configuration.nix
    ./disks.nix
  ];

  system.stateVersion = "25.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGsdARqD3MibvnpcUxOZVtstIu9djk+umwFR5tzqKATH root@iris";

  boot.loader.timeout = 1;

  boot.initrd.systemd.enable = true;

  zramSwap.enable = true;

  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.max_pool_percent=20"
    "zswap.shrinker_enabled=1"
  ];

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8 * 1024;
      priority = 2; # zram swap priority is 5
    }
  ];
}
