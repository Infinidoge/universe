{ lib, ... }: {
  boot.loader = {
    grub = {
      enable = lib.mkDefault true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };
}
