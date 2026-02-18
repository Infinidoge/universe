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

    ./dns.nix
  ];

  system.stateVersion = "25.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZFQ7Gg/N1wthHRuGQQCUcc5cMYFT5ARl5afEXD64ww root@iris";

  boot.loader.timeout = 1;

  boot.initrd.systemd.enable = true;

  networking.interfaces.enp3s0.ipv4.addresses = [
    {
      address = "45.8.201.122";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = {
    address = "45.8.201.1";
    interface = "enp3s0";
  };

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
