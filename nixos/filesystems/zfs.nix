{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages;
  boot.supportedFilesystems.zfs = true;
  boot.initrd.supportedFilesystems.zfs = true;

  # Disable force importing ZFS roots
  boot.zfs.forceImportRoot = false;
}
