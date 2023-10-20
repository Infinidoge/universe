{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [ "ahci" "nvme" "sd_mod" "usb_storage" "usbhid" "xhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
