{ pkgs, lib, ... }:
with lib.our.disko;
{
  boot.zfs.extraPools = [
    "main"
    "tank"
  ];

  disko.devices = {
    nodev."/" = mkTmpfs "64G";
    disk = {
      store = mkDisk "usb-HP_iLO_LUN_00_Media_0_000002660A01-0:0" {
        partitions = {
          boot = mkESP "512M" "/boot";
          store = mkBtrfsPart "100%" "/media/store" {
            subvolumes = mkBtrfsSubvols {
              "/etc/ssh" = { };
              "/etc/secrets" = { };
            };
          };
        };
      };

      hddL = mkZDisk "wwn-0x5000c50067267658" "main"; # 6 TB
      hddS1 = mkZDisk "wwn-0x5000cca22ced889d" "tank"; # 3 TB
      hddS2 = mkZDisk "wwn-0x5000cca22ceda094" "tank"; # 3 TB
      hddS3 = mkZDisk "wwn-0x5000cca22cedeb01" "tank"; # 3 TB
    };

    zpool = mkZPools {
      main = {
        mode = ""; # No second disk
        datasets = {
          nix = mkZfs "/nix" { };
          persist = mkZfs "/persist" { };
        };
      };
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
    "/etc/secrets"
  ];
}
