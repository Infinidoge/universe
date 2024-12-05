{ pkgs, lib, ... }:
with lib.our.disko;
{
  boot.kernelPackages = pkgs.linuxPackages;

  boot.zfs.extraPools = [ "tank" ];

  disko.devices = {
    nodev."/" = mkTmpfs "2G";
    disk = {
      main = mkDisk "usb-_USB_DISK_62859665-0:0" {
        partitions = {
          boot = mkESP "64M" "/boot/efi";
          store = mkBtrfsPart "100%" "/media/store" {
            subvolumes = mkBtrfsSubvols {
              "/boot" = { };
              "/etc/ssh" = { };
              "/persist" = { };
              "/nix" = { };
            };
          };
        };
      };
      hdd1 = mkZDisk "wwn-0x5000cca215d2481a" "tank";
      hdd2 = mkZDisk "wwn-0x5000cca215d24629" "tank";
    };

    zpool = mkZPools {
      tank = {
        datasets = {
          storage = mkZfs "/storage" { };
          backups = mkZfs "/backups" { };
          swap = mkZvol "16G" {
            type = "swap";
            resumeDevice = false;
            discardPolicy = "both";
          };
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
