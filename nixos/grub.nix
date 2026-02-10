{ lib, ... }:
{
  boot.loader = {
    timeout = lib.mkDefault 3;
    grub = {
      enable = true;
      device = lib.mkDefault "nodev";
      efiSupport = true;
      useOSProber = false;
      efiInstallAsRemovable = true;
    };
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot/efi";
    };
  };
}
