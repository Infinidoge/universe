{
  config,
  pkgs,
  lib,
  ...
}:
{
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
      peripherals = {
        printing.enable = true;
      };
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

  services.printing.drivers = with pkgs; [
    tmx-cups-ppd
  ];

  hardware.printers.ensurePrinters = [
    {
      name = "EPSON-TM-m30";
      deviceUri = "usb://EPSON/TM-m30II-NT?serial=5839394D0032780000";
      model = "tm-m30-rastertotmt.ppd.gz";
    }
  ];

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

  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.10.0.3/32" ];
    listenPort = 51820;
    privateKeyFile = "/home/infinidoge/tmp/bb-vpn.key";
    peers = [
      {
        publicKey = "SYpnrGvxx8l4w9c7KVRVW6GyNDr/iK+maPPMw/Ua7XY=";
        allowedIPs = [ "10.9.0.0/24" ];
        endpoint = "66.23.193.252:55555";
        persistentKeepalive = 25;
      }
    ];
  };
}
