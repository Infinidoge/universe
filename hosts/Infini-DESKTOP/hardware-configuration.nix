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

  fileSystems =
    let
      main = uuid "13f97ece-823e-4785-b06e-6c284105d379";
      esp = uuid "1DB7-2844";

      btrfsOptions = [ "defaults" "autodefrag" "noatime" ];
    in
    {
      "/" = {
        device = "none";
        fsType = "tmpfs";
        options = [ "defaults" "size=16G" "mode=755" ];
      };

      "/persist" = {
        device = main;
        fsType = "btrfs";
        options = [ "subvol=root" "autodefrag" "noatime" "ssd" ];
        neededForBoot = true;
      };

      "/persist/srv" = {
        device = main;
        fsType = "btrfs";
        options = [ "subvol=root/srv" "ssd" ] ++ btrfsOptions;
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
        device = uuid "2a025f29-4058-4a76-8f38-483f0925375d";
        fsType = "btrfs";
        options = [ "subvol=Hydrus" "autodefrag" "noatime" "ssd" ];
      };
    };

  swapDevices = [
    { device = uuid "37916097-dbb9-4a74-b761-17043629642a"; }
  ];

  info = {
    monitors = 3;
    model = "Custom Desktop";
  };
}
