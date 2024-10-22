{ ... }:
let
  uuid = uuid: "/dev/disk/by-uuid/${uuid}";
  main = uuid "9d4bf2d8-f139-42e7-937a-541a7870d806";
  data = uuid "456cebd3-f800-4733-a783-90ed7c8978f7";
  commonOptions = [ "autodefrag" "noatime" "ssd" "compress=zstd:1" ];

  mkMain' = options: {
    device = main;
    fsType = "btrfs";
    options = commonOptions ++ options;
  };
  mkMainOpt = options: (mkMain' options) // { neededForBoot = true; };
  mkMain = subvol: mkMainOpt [ "subvol=${subvol}" ];

  mkData' = options: {
    device = data;
    fsType = "btrfs";
    options = commonOptions ++ options;
  };
  mkDataOpt = options: (mkData' options) // { neededForBoot = true; };
  mkData = subvol: mkDataOpt [ "subvol=${subvol}" ];
in
{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=16G" "mode=755" ];
    };

    "/media/main" = mkMain' [ ];
    "/media/data" = mkData' [ ];
    "/persist" = mkMain "root";
    "/persist/srv" = mkData "root/srv";
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
