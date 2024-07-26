{ config, pkgs, lib, private, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "22.05";

  info.loc.home = true;

  modules = {
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
  };

  boot.loader.timeout = 1;

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
