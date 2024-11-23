{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
  ];

  system.stateVersion = "24.11";
  networking.hostId = "deadbeef";

  boot.kernelPackages = pkgs.linuxPackages;

  modules = {
    hardware = {
      audio.enable = true;
      form.portable = true;
    };
  };

  specialisation."Graphical".configuration = {
    modules.desktop.wm.enable = true;
  };
}
