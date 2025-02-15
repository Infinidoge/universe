{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "23.05";

  info.loc.purdue = true;

  boot.loader.timeout = 1;

  modules = {
    hardware.form.desktop = true;
    hardware.gpu.intel = true;
    hardware.peripherals.printing.enable = true;
    desktop.wm.enable = true;
  };

  services.printing = {
    listenAddresses = [
      "localhost:631"
      "100.101.102.18:631"
      "infini-optiplex:631"
    ];
    allowFrom = [ "all" ];
    defaultShared = true;
    openFirewall = true;
    drivers = [ pkgs.tmx-cups-ppd ];
  };

  hardware.printers.ensurePrinters = [
    {
      name = "EPSON-TM-m30";
      deviceUri = "usb://EPSON/TM-m30II-NT?serial=5839394D0032780000";
      model = "tm-m30-rastertotmt.ppd.gz";
    }
  ];

  persist = {
    directories = [
    ];

    files = [
    ];
  };
}
