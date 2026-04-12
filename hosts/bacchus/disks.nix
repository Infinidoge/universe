{ lib, ... }:
with lib.our.disko;
{
  disko.devices = {
    nodev."/" = mkTmpfs "4G";
    disk = {
      main = mkDisk "nvme-KINGSTON_RBUSNS8154P3256GJ1_50026B7683C61FD2" {
        partitions = {
          boot = mkESP "64M" "/boot/efi";
          main = mkBtrfsPart "100%" "/media/main" {
            subvolumes = mkBtrfsSubvols {
              "/boot" = { };
              "/etc/ssh" = { };
              "/persist" = { };
              "/nix" = { };
              "/swap" = { };
            };
          };
        };
      };
    };
  };

  fileSystems = markNeededForBoot [
    "/persist"
    "/etc/ssh"
  ];
}
