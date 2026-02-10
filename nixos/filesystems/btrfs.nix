{ pkgs, ... }:
{
  boot.supportedFilesystems.btrfs = true;
  boot.initrd.supportedFilesystems.btrfs = true;

  environment.systemPackages = with pkgs; [
    btrfs-progs
    compsize
  ];
}
