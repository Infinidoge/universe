{ config, lib, pkgs, modulesPath, ... }:

let
  uuid = uuid: "/dev/disk/by-uuid/${uuid}";
in
{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "boot.shell_on_fail" ];
  boot.supportedFilesystems = [ "btrfs" ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;

  fileSystems =
    let
      main = uuid "13f97ece-823e-4785-b06e-6c284105d379";
      esp = uuid "1DB7-2844";
    in
    {
      "/" = {
        device = "none";
        fsType = "tmpfs";
        options = [ "defaults" "size=4G" "mode=755" ];
      };

      "/persist" = {
        device = main;
        fsType = "btrfs";
        options = [ "subvol=root" "autodefrag" "noatime" "ssd" ];
        neededForBoot = true;
      };

      "/etc/ssh" = {
        device = main;
        fsType = "btrfs";
        options = [ "subvolid=262" "autodefrag" "noatime" "ssd" ];
        neededForBoot = true;
      };

      "/media/main" = {
        device = main;
        fsType = "btrfs";
        options = [ "autodefrag" "noatime" "ssd" ];
      };

      "/nix" = {
        device = main;
        fsType = "btrfs";
        options = [ "subvol=nix" "autodefrag" "noatime" "ssd" ];
        neededForBoot = true;
      };

      "/boot" = {
        device = main;
        fsType = "btrfs";
        options = [ "subvol=boot" "autodefrag" "noatime" "ssd" ];
        neededForBoot = true;
      };

      "/boot/efi" = {
        device = esp;
        fsType = "vfat";
        neededForBoot = true;
      };

      "/home/infinidoge/Hydrus" = {
        device = uuid "b26b002b-2ed5-44ea-8018-f65c994a79cb";
        fsType = "btrfs";
        options = [ "subvol=Hydrus" "autodefrag" "noatime" "ssd" ];
      };
    };

  swapDevices = [
    { device = uuid "37916097-dbb9-4a74-b761-17043629642a"; }
  ];
}
