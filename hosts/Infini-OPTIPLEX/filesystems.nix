{ config, lib, pkgs, ... }:
let
  uuid = uuid: "/dev/disk/by-uuid/${uuid}";
  main = uuid "9d4bf2d8-f139-42e7-937a-541a7870d806";
  commonOptions = [ "autodefrag" "noatime" "ssd" "compress=zstd:1" ];

  mkMain' = options: {
    device = main;
    fsType = "btrfs";
    options = commonOptions ++ options;
  };
  mkMainOpt = options: (mkMain' options) // { neededForBoot = true; };
  mkMain = subvol: mkMainOpt [ "subvol=${subvol}" ];
in
{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=16G" "mode=755" ];
    };

    "/media/main" = mkMain' [ ];
    "/persist" = mkMain "root";
    "/etc/ssh" = mkMain "root/etc/ssh";
    "/nix" = mkMain "nix";
    "/boot" = mkMain "boot";

    "/boot/efi" = {
      device = uuid "23B2-DCD2";
      fsType = "vfat";
      neededForBoot = true;
    };
  };

  swapDevices = [
    { device = uuid "a002985f-68c9-46a1-b62e-1c6aec6bd3f3"; }
  ];
}
