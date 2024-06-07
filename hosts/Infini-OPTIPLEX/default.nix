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

    hardware.form.server = true;
  };

  persist = {
    directories = [
    ];

    files = [
    ];
  };
}
