{ config, lib, ... }:
with lib;
{
  persist = {
    directories = [
      "/home"
      "/etc/nixos"
      "/etc/nixos-private"

      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"

      "/root/.ssh"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
