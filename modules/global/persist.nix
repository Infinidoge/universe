{ config, lib, ... }:
let
  inherit (lib) flatten optional;
in
{
  persist = {
    directories = flatten [
      "/home"
      {
        directory = "/etc/nixos";
        user = "infinidoge";
      }
      {
        directory = "/etc/nixos-private";
        user = "infinidoge";
      }

      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/"
      {
        directory = "/var/lib/tailscale";
        mode = "0700";
      }

      "/root/.ssh"

      (optional config.services.fprintd.enable "/var/lib/fprint")
      (optional (config.security.acme.certs != { }) "/var/lib/acme")
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  # https://github.com/NixOS/nixpkgs/pull/351151
  boot.initrd.systemd.suppressedUnits = [ "systemd-machine-id-commit.service" ];
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
}
