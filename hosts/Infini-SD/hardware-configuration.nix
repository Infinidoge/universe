{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "usb_storage" ];
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "boot.shell_on_fail" ];
  boot.supportedFilesystems = [ "btrfs" "zfs" ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  info.model = "SD Card Installation";
}
