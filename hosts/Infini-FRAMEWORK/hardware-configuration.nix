# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

let
  uuid = uuid: "/dev/disk/by-uuid/${uuid}";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=4G" "mode=755" ];
    };

    "/persist" = {
      device = uuid "a44af0ff-5667-465d-b80a-1934d1aab8d9";
      fsType = "btrfs";
      options = [ "subvol=root" "autodefrag" "noatime" ];
      neededForBoot = true;
    };

    "/nix" = {
      device = uuid "a44af0ff-5667-465d-b80a-1934d1aab8d9";
      fsType = "btrfs";
      options = [ "subvol=nix" "autodefrag" "noatime" ];
      neededForBoot = true;
    };

    "/boot" = {
      device = uuid "a44af0ff-5667-465d-b80a-1934d1aab8d9";
      fsType = "btrfs";
      options = [ "subvol=boot" "autodefrag" "noatime" ];
      neededForBoot = true;
    };

    "/boot/efi" = {
      device = uuid "3FC9-0182";
      fsType = "vfat";
      neededForBoot = true;
    };
  };

  swapDevices = [{ device = uuid "28672ffb-9f1c-462b-b49d-8a14b3dd72b3"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
