{ config, lib, pkgs, modulesPath, ... }:

let
  uuid = uuid: "/dev/disk/by-uuid/${uuid}";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "usb_storage" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "boot.shell_on_fail" ];
  boot.supportedFilesystems = [ "btrfs" ];

  fileSystems =
    let
      main = uuid "5f24b2a6-643d-4abd-a3b2-61ee124700b5";
      esp = uuid "A2B8-4C6E";
      data = uuid "59abb0ff-fe4e-4061-87d2-b728b937656a";

      btrfsOptions = [ "defaults" "autodefrag" "noatime" ];
    in
    {
      "/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [ "defaults" "size=4G" "mode=755" ];
      };

      "/media/main" = {
        device = main;
        fsType = "btrfs";
        options = [ "subvol=/" "ssd" ] ++ btrfsOptions;
        neededForBoot = true;
      };

      "/media/data" = lib.mkIf (data != null) {
        device = data;
        fsType = "btrfs";
        options = [ "subvol=/" "ssd" ] ++ btrfsOptions;
        neededForBoot = true;
      };

      "/persist" = {
        device = main;
        fsType = "btrfs";
        options = [ "subvol=root" "ssd" ] ++ btrfsOptions;
        neededForBoot = true;
      };

      "/etc/ssh" = {
        device = main;
        fsType = "btrfs";
        options = [ "subvolid=264" "ssd" ] ++ btrfsOptions;
        neededForBoot = true;
      };

      "/persist/srv" = lib.mkIf (data != null) {
        device = data;
        fsType = "btrfs";
        options = [ "subvol=root/srv" "ssd" ] ++ btrfsOptions;
        neededForBoot = true;
      };

      # "/persist" = {
      #   device = "overlay";
      #   fsType = "overlay";
      #   options = [
      #     "upperdir=/media/main/root"
      #     "lowerdir=/media/data/root"
      #     "workdir=/media/main/work"
      #     "redirect_dir=on"
      #   ];
      #   neededForBoot = true;
      # };

      "/nix" = {
        device = main;
        fsType = "btrfs";
        options = [ "subvol=nix" "ssd" ] ++ btrfsOptions;
        neededForBoot = true;
      };

      "/boot" = {
        device = main;
        fsType = "btrfs";
        options = [ "subvol=boot" "ssd" ] ++ btrfsOptions;
        neededForBoot = true;
      };

      "/boot/efi" = {
        device = esp;
        fsType = "vfat";
        neededForBoot = true;
      };
    };

  swapDevices = [
    { device = uuid "b064d69c-0310-4a94-a0de-a4b358f54f9e"; }
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  info = {
    monitors = 0;
    model = "Headless Server";
  };
}
