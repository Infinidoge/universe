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
      { directory = "/var/lib/tailscale"; mode = "0700"; }

      "/root/.ssh"

      (optional config.services.fprintd.enable "/var/lib/fprint")
      (optional (config.security.acme.certs != { }) "/var/lib/acme")
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
