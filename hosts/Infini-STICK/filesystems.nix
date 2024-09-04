{ ... }:

let
  uuid = uuid: "/dev/disk/by-uuid/${uuid}";
  commonOptions = [ "autodefrag" "noatime" "compress-force=zstd:1" ];

  mkMain' = options: {
    device = uuid "85d60c21-bc62-471e-b305-f7e26499adb3";
    fsType = "btrfs";
    options = commonOptions ++ options;
  };
  mkMain = options: (mkMain' options) // { neededForBoot = true; };
in
{
  environment.etc.crypttab.text = ''
    vault UUID=8fe59989-cd9c-4142-bdf7-fc748cb56b34 - luks,noauto
  '';

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=4G" "mode=755" ];
    };

    "/media/main" = mkMain' [ ];
    "/media/storage" = {
      device = uuid "B56A-F857";
      fsType = "exfat";
      options = [ "defaults" "noatime" ];
    };
    "/media/vault" = {
      device = "/dev/mapper/vault";
      fsType = "ext4";
      options = [ "defaults" "noauto" ];
    };

    "/persist" = mkMain [ "subvol=root" ];
    "/etc/ssh" = mkMain [ "subvol=root/etc/ssh" ];
    "/nix" = mkMain [ "subvol=nix" ];
    "/boot" = mkMain [ "subvol=boot" ];

    "/boot/efi" = {
      device = uuid "C167-F1F0";
      fsType = "vfat";
      neededForBoot = true;
    };
  };
}
