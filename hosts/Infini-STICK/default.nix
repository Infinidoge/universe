{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "24.11";
  networking.hostId = "06a3f197";

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
