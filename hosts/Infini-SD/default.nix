{ lib, config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  networking.hostId = "3275c7d3";

  boot.kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;

  modules = {
    boot.grub.enable = true;
    hardware = {
      form.server = true;
    };
  };

  persist = {
    directories = [
      "/home"
      "/etc/nixos"
      "/etc/nixos-private"

      "/root/.local/share/nix"
      "/root/.ssh"

      # /var directories
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"
    ];

    files = [
      "/etc/machine-id"
    ];
  };

  system.stateVersion = "23.11";
}
