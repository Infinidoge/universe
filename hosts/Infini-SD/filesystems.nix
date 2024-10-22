{ ... }:

let
  uuid = uuid: "/dev/disk/by-uuid/${uuid}";
  main = uuid "527062b3-7a48-4456-8527-30887c6e9f52";
  commonOptions = [ "autodefrag" "noatime" "compress-force=zstd:1" ];

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
      options = [ "defaults" "size=64G" "mode=755" ];
    };

    "/media/main" = mkMain' [ ];

    "/persist" = mkMain [ "subvol=root" ];
    "/etc/ssh" = mkMain [ "subvol=root/etc/ssh" ];
    "/nix" = mkMain [ "subvol=nix" ];
    "/boot" = mkMain [ "subvol=boot" ];

    "/boot/efi" = {
      device = uuid "E41C-506A";
      fsType = "vfat";
      neededForBoot = true;
    };
  };
}
