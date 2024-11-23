{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
  ];

  system.stateVersion = "25.05";
  networking.hostId = "85eb2d89"; # "hestia" in base64->hex

  modules.hardware.form.server = true;
  modules.backups.enable = false; # hestia is a backup target
  boot.loader.timeout = 1;
}
