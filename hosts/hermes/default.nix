{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
  ];

  system.stateVersion = "24.11";
  networking.hostId = "deadbeef";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0fWuozCHyPrkFKPcnqX1MyUAgnn2fJEpDSoD7bhDA4 root@Infini-STICK";

  boot.kernelPackages = pkgs.linuxPackages;

  modules = {
    hardware = {
      audio.enable = true;
      form.portable = true;
    };
  };

  universe.programming.c.enable = false;

  specialisation.graphical.configuration = {
    modules.desktop.wm.enable = true;
  };
}
