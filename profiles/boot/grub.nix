{ lib, ... }:
with lib;
{
  boot.loader = {
    grub = {
      enable = mkDefault true;
      device = mkDefault "nodev";
      efiSupport = mkDefault true;
      useOSProber = mkDefault false;
      efiInstallAsRemovable = mkDefault true;
    };
    efi = {
      canTouchEfiVariables = mkDefault false;
      efiSysMountPoint = mkDefault "/boot/efi";
    };
  };
}
