{ config, pkgs, lib, private, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "22.05";

  info.loc.home = true;

  modules = {
    boot = {
      grub.enable = true;
      timeout = 1;
    };
    hardware = {
      # gpu.nvidia = true;
      form.server = true;
    };
    services.apcupsd = {
      enable = false;
      primary = false;
      config = {
        address = "192.168.1.212";
      };
    };

    backups.extraExcludes = [
      "/srv/minecraft/emd-server/world-backups"
    ];
  };

  services = {
    avahi.reflector = true;
  };

  persist = {
    directories = [
      "/srv"
    ];

    files = [
    ];
  };
}
