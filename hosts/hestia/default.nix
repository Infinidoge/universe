{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
  ];

  system.stateVersion = "25.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBanlhzmtBf5stg2yYdxqb9FzFZmum/rlWod/akWQI3c root@hestia";

  networking.hostId = "85eb2d89"; # "hestia" in base64->hex

  modules.hardware.form.server = true;
  modules.backups.enable = false; # hestia is a backup target
  boot.loader.timeout = 1;
}
