{ lib, config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  networking.hostId = "3275c7d3";

  boot.kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;

  modules = {
    boot.grub.enable = true;
    hardware = {
      form.server = true;
    };
  };

  documentation.man.man-db.enable = false;

  persist = {
    directories = [
    ];

    files = [
    ];
  };

  system.stateVersion = "23.11";
}
