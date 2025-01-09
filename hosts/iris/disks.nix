{ pkgs, lib, ... }:
with lib.our.disko;
{
  boot.kernelPackages = pkgs.linuxPackages;

  boot.zfs.extraPools = [ "tank" ];

  disko.devices = {
    nodev."/" = mkTmpfs "2G";
    disk = {
      main = mkDisk "wwn-0x6034a134b1c4432588a23b05f3802d24" {
        partitions = {
          boot = mkESP "64M" "/boot/efi";
          main = mkBtrfsPart "100%" "/media/main" {
            subvolumes = mkBtrfsSubvols {
              "/boot" = { };
              "/etc/ssh" = { };
              "/persist" = { };
              "/nix" = { };
            };
          };
        };
      };
    };
  };

  fileSystems = markNeededForBoot [
    "/persist"
    "/etc/ssh"
    "/home"
  ];
}
