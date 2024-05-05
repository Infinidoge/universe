{ lib }:
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
    } // content;
  };

  # ZFS

  mkZDisk = id: pool: mkDisk id {
    partitions = {
      zfs = {
        size = "100%";
        content = {
          type = "zfs";
          inherit pool;
        };
      };
    };
  };

  mkZPool' = mountOptions: name: options: {
    type = "zpool";
    mode = "raidz";
    mountpoint = "/media/${name}";
    rootFsOptions = {
      compression = "zstd";
      atime = "off";
    };
    inherit mountOptions;
  } // options;
  mkZPool = mkZPool' defaultMountOptions;

  mkZfs' = mountOptions: mountpoint: options: {
    type = "zfs_fs";
    inherit mountpoint mountOptions options;
  };
  mkZfs = mkZfs' defaultMountOptions;

  mkZvol = size: content: {
    type = "zfs_volume";
    inherit size content;
  };
}
