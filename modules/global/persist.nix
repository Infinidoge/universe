{ config, lib, ... }:
let
  inherit (lib) flatten optional;
in
{
  persist = {
    directories = flatten [
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
