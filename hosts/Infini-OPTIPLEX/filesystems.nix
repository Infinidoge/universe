{ config, lib, pkgs, ... }:
let
  uuid = uuid: "/dev/disk/by-uuid/${uuid}";
  main = uuid "9d4bf2d8-f139-42e7-937a-541a7870d806";
  commonOptions = [ "autodefrag" "noatime" "ssd" "compress=zstd:1" ];
in
{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=16G" "mode=755" ];
    };

    "/media/main" = {
      device = main;
      fsType = "btrfs";
      options = commonOptions;
    };

    "/persist" = {
      device = main;
      fsType = "btrfs";
      options = [ "subvol=root" ] ++ commonOptions;
      neededForBoot = true;
    };

    "/etc/ssh" = {
      device = main;
      fsType = "btrfs";
      options = [ "subvol=root/etc/ssh" ] ++ commonOptions;
      neededForBoot = true;
    };

    "/nix" = {
      device = main;
      fsType = "btrfs";
      options = [ "subvol=nix" ] ++ commonOptions;
      neededForBoot = true;
    };

    "/boot" = {
      device = main;
      fsType = "btrfs";
      options = [ "subvol=boot" ] ++ commonOptions;
      neededForBoot = true;
    };

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
