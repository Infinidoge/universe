{ lib, ... }:

let
  uuid = uuid: "/dev/disk/by-uuid/${uuid}";

  main = uuid "5f24b2a6-643d-4abd-a3b2-61ee124700b5";
  esp = uuid "A2B8-4C6E";
  data = uuid "59abb0ff-fe4e-4061-87d2-b728b937656a";

  commonOptions = [
    "autodefrag"
    "noatime"
    "ssd"
  ];
in
{

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=4G"
        "mode=755"
      ];
    };

    "/media/main" = {
      device = main;
      fsType = "btrfs";
      options = [ "subvol=/" ] ++ commonOptions;
      neededForBoot = true;
    };

    "/media/data" = lib.mkIf (data != null) {
      device = data;
      fsType = "btrfs";
      options = [ "subvol=/" ] ++ commonOptions;
      neededForBoot = true;
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
      options = [ "subvolid=264" ] ++ commonOptions;
      neededForBoot = true;
    };

    "/persist/srv" = lib.mkIf (data != null) {
      device = data;
      fsType = "btrfs";
      options = [ "subvol=root/srv" ] ++ commonOptions;
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
      device = esp;
      fsType = "vfat";
      neededForBoot = true;
    };
  };

  swapDevices = [
    { device = uuid "b064d69c-0310-4a94-a0de-a4b358f54f9e"; }
  ];
}
