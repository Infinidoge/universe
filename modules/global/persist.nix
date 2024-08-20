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
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"

      "/root/.ssh"

      (optional config.services.fprintd.enable "/var/lib/fprint")
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
