{ config, lib, pkgs, ... }:

let
  uuid = uuid: "/dev/disk/by-uuid/${uuid}";
  main = uuid "ae3f3d98-1d87-47b4-a4ed-d69a896eee69";
  commonOptions = [ "autodefrag" "noatime" "compress-force=zstd:7" ];

  mkMain' = options: {
    device = main;
    fsType = "btrfs";
    options = commonOptions ++ options;
  };
  mkMain = options: (mkMain' options) // { neededForBoot = true; };
in
{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=4G" "mode=755" ];
    };

    "/media/main" = mkMain' [ ];

    "/persist" = mkMain [ "subvol=root" ];
    "/etc/ssh" = mkMain [ "subvol=root/etc/ssh" ];
    "/nix" = mkMain [ "subvol=nix" ];
    "/boot" = mkMain [ "subvol=boot" ];

    "/boot/efi" = {
      device = uuid "D7DB-2291";
      fsType = "vfat";
      neededForBoot = true;
    };
  };
}
