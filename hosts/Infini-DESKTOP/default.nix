{ config, pkgs, lib, ... }: {
  imports = lib.lists.flatten [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "21.11";

  info.loc.home = true;

  persist = {
    directories = [
      "/srv"
    ];

    files = [
    ];
  };

  modules = {
    hardware = {
      gpu.nvidia = true;
      wireless.enable = true;
      form.desktop = true;
    };
    services = {
      apcupsd = {
        enable = true;
        primary = true;
        config = {
          address = "0.0.0.0";
        };
      };
    };
    desktop = {
      wm.enable = true;
      gaming.enableAll = true;
      gaming.olympus.enable = false; # Build is currently broken
    };

    backups.extraExcludes = [
      "/home/infinidoge/Hydrus"
    ];
  };

  virtualisation.enable = true;

  universe.programming.all.enable = true;

  home.home.packages = with pkgs; [
    arduino
    hydrus
    sidequest
    razergenie # TODO: replace with polychromatic
  ];


  programs.ns-usbloader.enable = true;
  programs.minipro.enable = true;

  hardware.openrazer = {
    enable = true;
    users = [ config.user.name ];
  };

  services.minecraft-servers = {
    enable = true;

    servers = { };
  };
}
