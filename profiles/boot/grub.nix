{ lib, ... }: {
  boot.loader = {
    grub = {
      enable = lib.mkDefault true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      efiInstallAsRemovable = lib.mkDefault true;
    };
    efi = {
      canTouchEfiVariables = lib.mkDefault false;
      efiSysMountPoint = "/boot/efi";
    };
  };
}
