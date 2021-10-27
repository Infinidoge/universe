{ lib, ... }: {
  boot.loader = {
    grub = {
      enable = lib.mkDefault true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      efiInstallAsRemovable = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };
}
