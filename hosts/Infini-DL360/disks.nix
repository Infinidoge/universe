{ config, lib, ... }:
with lib.disko;
let
  inherit (builtins) mapAttrs;
  mountOptions = defaultMountOptions;
in
{
  boot.kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;

  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = mountOptions ++ [
        "size=64G"
        "mode=755"
      ];
    };
    disk = {
      lun = "usb-HP_iLO_LUN_01_Media_0_000002660A01-0:1" {
        partitions = {
          ESP = {
            name = "boot";
            size = "256M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              inherit mountOptions;
            };
          };
          # Keystore partition?
          #keystore = {
          #  size = "100%";
          #};
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
    zpool = mapAttrs mkZPool {
      zssd = {
        nix = mkZfs "/nix" {};
        persist = mkZfs "/persist" {};
      };
      zhdd = {
        storage = mkZfs "/storage" {};
      };
    };
  };
}
