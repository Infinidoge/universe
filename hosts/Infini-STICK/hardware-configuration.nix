{ config, lib, pkgs, modulesPath, ... }:

let
  uuid = uuid: "/dev/disk/by-uuid/${uuid}";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "usb_storage" ];
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "boot.shell_on_fail" ];
  boot.supportedFilesystems = [ "btrfs" ];

  fileSystems =
    let
      # main = uuid "2a87bd84-c453-4b76-969c-e0653391131e";
      # esp = uuid "0339-DFBA";
      main = uuid "10e03644-e9b8-4f0c-b1e5-42193c2969d1";
      esp = uuid "37A3-9E22";
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
    };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  info.model = "Portable Installation";
}
