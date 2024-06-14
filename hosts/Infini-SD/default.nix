{ lib, config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  networking.hostId = "3275c7d3";

  boot.kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;

  hardware.infiniband = {
    enable = true;
  };

  modules = {
    boot.grub.enable = true;
    hardware = {
      form.server = true;
    };
  };

  networking = {
    interfaces.eno4 = {
      ipv4.addresses = [{
        address = "128.210.6.109";
        prefixLength = 28;
      }];
    };
    defaultGateway = {
      address = "128.210.6.97";
      interface = "eno4";
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
