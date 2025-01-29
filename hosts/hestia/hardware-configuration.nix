{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "boot.shell_on_fail" ];
  boot.supportedFilesystems = [
    "btrfs"
    "zfs"
  ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  info.model = "Dell R330";
}
