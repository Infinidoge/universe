{ config, pkgs, lib, private, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "23.05";

  info.loc.purdue = true;

  modules = {
    boot = {
      grub.enable = true;
      timeout = 1;
    };

    hardware.form.desktop = true;
    hardware.gpu.intel = true;
    desktop.wm.enable = true;
  };

  persist = {
    directories = [
    ];

    files = [
    ];
  };
}
