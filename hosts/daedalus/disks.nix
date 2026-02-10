{ pkgs, lib, ... }:
with lib.our.disko;
{
  boot.zfs.extraPools = [
    "zssd"
    "zhdd"
  ];

  disko.devices = {
    nodev."/" = mkTmpfs "64G";
    disk = {
      lun = mkDisk "usb-HP_iLO_LUN_01_Media_0_000002660A01-0:1" {
        partitions = {
          boot = mkESP "64M" "/boot/efi";
          store = mkBtrfsPart "100%" "/media/store" {
            subvolumes = mkBtrfsSubvols {
              "/boot" = { };
              "/etc/ssh" = { };
              "/etc/secrets" = { };
            };
          };
        };
      };
      ssd1 = mkZDisk "wwn-0x50026b728203a6fb" "zssd";
      ssd2 = mkZDisk "wwn-0x50026b72780172e3" "zssd";
      ssd3 = mkZDisk "wwn-0x50026b727801727b" "zssd";
      hdd1 = mkZDisk "wwn-0x5000c5004da15fce" "zhdd";
      hdd2 = mkZDisk "wwn-0x5000c5004d9a5e51" "zhdd";
      hdd3 = mkZDisk "wwn-0x5000c5004da92a24" "zhdd";
      hdd4 = mkZDisk "wwn-0x5000c5004d30f464" "zhdd";
      hdd5 = mkZDisk "wwn-0x5000c5004d30dc88" "zhdd";
    };
    zpool = mkZPools {
      zssd = {
        datasets = {
          nix = mkZfs "/nix" { };
          persist = mkZfs "/persist" { };
        };
      };
      zhdd = {
        datasets = {
          storage = mkZfs "/storage" { };
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
