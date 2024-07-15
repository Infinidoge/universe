{ lib, self }:

rec {
  diskByUuid = uuid: "/dev/disk/by-uuid/${uuid}";

  mkFilesystemDev = fsType: device: common: options: {
    inherit device fsType;
    options = common ++ options;
  };

  neededForBoot = self.lazy (fs: fs // { neededForBoot = true; });

  mkFilesystemDev' = f: d: c: o:
    neededForBoot (mkFilesystemDev f d c o);

  mkFilesystem = fsType: uuid:
    mkFilesystemDev fsType (diskByUuid uuid);

  mkFilesystem' = f: d: c: o:
    neededForBoot (mkFilesystemDev f d c o);


  mkEFI = uuid: neededForBoot {
    device = diskByUuid uuid;
    fsType = "vfat";
  };
  mkTmpfs = name: size: neededForBoot {
    device = name;
    fsType = "tmpfs";
    options = [ "defaults" "size=${size}" "mode=755" ];
  };
  mkBtrfs' = options: uuid: extraOptions: {
    device = diskByUuid uuid;
    fsType = "btrfs";
    options = options ++ extraOptions;
  };
  mkBtrfs = mkBtrfs' [
    "autodefrag"
    "noatime"
    "ssd"
    "compress=zstd:1"
  ];

  mkSwap = uuid: { device = diskByUuid uuid; };
}
