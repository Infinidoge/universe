{ ... }:

{
  boot.initrd.availableKernelModules = [
    "nvme"
    "ahci"
    "xhci_pci"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  info = {
    monitors = 3;
    model = "Custom Desktop";
  };

  hardware.nvidia.open = true;
}
