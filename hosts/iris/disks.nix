{ lib, ... }:
with lib.our.disko;
let
  mountOptions = defaultMountOptions ++ [
    "autodefrag"
    "compress=zstd:3"
  ];
in
{
  disko.devices = {
    nodev."/" = mkTmpfs "1G";
    disk = {
      main = mkDisk' "/dev/vda" {
        partitions = {
          boot = mkESP "64M" "/boot/efi";
          main = mkBtrfsPart "100%" "/media/main" {
            subvolumes = mkBtrfsSubvols' mountOptions {
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
