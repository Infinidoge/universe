{ config, lib, pkgs, ... }:

let
  uuid = uuid: "/dev/disk/by-uuid/${uuid}";
  main = uuid "a44af0ff-5667-465d-b80a-1934d1aab8d9";
  commonOptions = [ "autodefrag" "noatime" "ssd" ];
in
{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=8G" "mode=755" ];
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
      options = [ "subvolid=628" ] ++ commonOptions;
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
      device = uuid "3FC9-0182";
      fsType = "vfat";
      neededForBoot = true;
    };
  };

  swapDevices = [
    { device = uuid "28672ffb-9f1c-462b-b49d-8a14b3dd72b3"; }
  ];
}
