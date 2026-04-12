{ lib, ... }:
with lib.our.disko;
{
  disko.devices = {
    nodev."/" = mkTmpfs "1G";
    disk = {
      main = mkDisk' "/dev/vda" {
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
