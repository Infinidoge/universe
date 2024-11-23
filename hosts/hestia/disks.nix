{ pkgs, lib, ... }:
with lib.our.disko;
{
  boot.kernelPackages = pkgs.linuxPackages;

  boot.zfs.extraPools = [ "tank" ];

  disko.devices = {
    nodev."/" = mkTmpfs "2G";
    disk = {
      hdd1 = mkDisk "wwn-0x5000c50015bda593" {
        partitions = {
          boot = mkESP "64M" "/boot/efi";
          store = mkBtrfsPartEndAt "238400M" "/media/store" {
            # 1/4th of 1000GB/931.5GiB
            subvolumes = mkBtrfsSubvols {
              "/boot" = { };
              "/etc/ssh" = { };
              "/persist" = { };
              "/nix" = { };
            };
          };
          zfs = mkZPart "100%" "tank";
        };
      };
      hdd2 = mkZDisk "wwn-0x5000cca215d2481a" "tank";
      hdd3 = mkZDisk "wwn-0x5000cca215d24629" "tank";
    };

    zpool = mkZPools {
      tank = {
        datasets = {
          storage = mkZfs "/storage" { };
          backups = mkZfs "/backups" { };
        };
      };
    };
  };

  fileSystems = markNeededForBoot [
    "/persist"
    "/storage"
    "/etc/ssh"
    "/home"
  ];
}
