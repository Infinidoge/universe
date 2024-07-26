{ pkgs, lib, ... }: {
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

      # FIXME: openrazer does not properly build under Linux 5.18
      # peripherals.razer.enable = true;
    };
    services = {
      foldingathome = {
        enable = false;
        user = "Infinidoge";
        extra = {
          control = true;
          viewer = true;
        };
      };
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
    software.minipro.enable = true;

    backups.extraExcludes = [
      "/home/infinidoge/Hydrus"
    ];
  };

  virtualisation.enable = true;

  home = { pkgs, ... }: {
    home.packages = with pkgs; [
      arduino
      hydrus
      sidequest
    ];
  };

  programs.ns-usbloader.enable = true;

  services.minecraft-servers = {
    enable = true;

    servers = { };
  };
}
