{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  boot.loader = {
    timeout = mkDefault 3;
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
