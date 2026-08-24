{ pkgs, nixos, ... }:
{
  imports = with nixos; [
    base
    backups
    borg
    email
    fail2ban
    grub
    home-manager
    locale
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
    tailscale
    filesystems.btrfs

    ./hardware-configuration.nix
    ./disks.nix

    ./dns.nix
    ./grafana.nix
    ./loki.nix
    ./ntfy.nix
    ./prometheus.nix
    ./uptime-kuma.nix
  ];

  system.stateVersion = "25.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZFQ7Gg/N1wthHRuGQQCUcc5cMYFT5ARl5afEXD64ww root@iris";

  info.model = "Pyro Eco VPS";

  boot.loader.timeout = 1;

  boot.initrd.systemd.enable = true;

  environment.systemPackages = with pkgs; [ bind ];

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

  boot.zswap.maxPoolPercent = 50;

  services.journald.extraConfig = ''
    SystemMaxUse=5%
  '';

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 4 * 1024;
      priority = 2;
    }
  ];
}
