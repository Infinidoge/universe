{ ... }:
{
  imports = [
    #./hardware-configuration.nix
    ./disks.nix
  ];

  system.stateVersion = "25.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGsdARqD3MibvnpcUxOZVtstIu9djk+umwFR5tzqKATH root@iris";

  modules.hardware.form.server = true;
  modules.backups.enable = false; # testing server
  boot.loader.timeout = 1;
}
