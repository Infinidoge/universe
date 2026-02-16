{ lib }:
let
  inherit (builtins) mapAttrs removeAttrs;
  inherit (lib) optionals flip genAttrs;
in
rec {
  # Constants

  defaultMountOptions = [
    "defaults"
    "noatime"
  ];

  # Common

  mkDisk = id: content: {
    type = "disk";
    device = "/dev/disk/by-id/${id}";
    content = {
      type = "gpt";
    }
    // content;
  };

  mkDisk' = device: content: {
    type = "disk";
    inherit device;
    content = {
      type = "gpt";
    }
    // content;
  };

  mkESP' = mountOptions: size: mountpoint: {
    inherit size;
    type = "EF00";
    content = {
      type = "filesystem";
      format = "vfat";
      inherit mountpoint mountOptions;
    };
  };
  mkESP = mkESP' defaultMountOptions;

  mkTmpfs' = mountOptions: size: mode: {
    fsType = "tmpfs";
    mountOptions = mountOptions ++ [
      "size=${size}"
      "mode=${mode}"
    ];
  };
  mkTmpfs = size: mkTmpfs' defaultMountOptions size "755";

  # btrfs

  mkBtrfsPart' =
    base: mountpoint: content':
    {
      content = {
        inherit mountpoint;
        type = "btrfs";
      }
      // content';
    }
    // base;
  mkBtrfsPart = size: mkBtrfsPart' { inherit size; };
  mkBtrfsPartEndAt = end: mkBtrfsPart' { inherit end; };

  mkBtrfsSubvols' =
    mountOptions:
    mapAttrs (
      n: v:
      {
        mountpoint = n;
        mountOptions = mountOptions ++ (optionals (v ? mountOptions) v.mountOptions);
      }
      // (removeAttrs v [ "mountOptions" ])
    );
  mkBtrfsSubvols = mkBtrfsSubvols' defaultMountOptions;

  # ZFS

  mkZPart' =
    base: content: pool:
    {
      content = {
        type = "zfs";
        inherit pool;
      }
      // content;
    }
    // base;
  mkZPart = size: mkZPart' { inherit size; } { };
  mkZPartEndAt = end: mkZPart' { inherit end; } { };

  mkZDisk =
    id: pool:
    mkDisk id {
      partitions = {
        zfs = mkZPart "100%" pool;
      };
    };

  mkZPool' =
    mountOptions: name: options:
    {
      type = "zpool";
      mode = "raidz";
      mountpoint = "/media/${name}";
      rootFsOptions = {
        mountpoint = "legacy";
        compression = "zstd";
        atime = "off";
      };
      inherit mountOptions;
    }
    // options;
  mkZPool = mkZPool' defaultMountOptions;
  mkZPools = mapAttrs mkZPool;

  mkZfs' = mountOptions: mountpoint: options: {
    type = "zfs_fs";
    inherit mountpoint mountOptions;
    options = {
      mountpoint = "legacy";
    }
    // options;
  };
  mkZfs = mkZfs' defaultMountOptions;

  mkZvol = size: content: {
    type = "zfs_volume";
    inherit size content;
  };

  mkSwap = size: content: {
    inherit size;
    content = {
      type = "swap";
    }
    // content;
  };

  markNeededForBoot = flip genAttrs (_: {
    neededForBoot = true;
  });
}
