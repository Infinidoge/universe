{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.services.printing.enable {
  services.printing.drivers = with pkgs; [
    tmx-cups-ppd
  ];

  hardware.printers.ensurePrinters = [
    {
      name = "EPSON-TM-m30";
      deviceUri = "usb://EPSON/TM-m30II-NT?serial=5839394D0032780000";
      model = "tm-m30-rastertotmt.ppd.gz";
    }
    {
      name = "EPSON-TM-m30-remote";
      deviceUri = "ipp://100.101.102.18/printers/EPSON-TM-m30";
      model = "raw";
    }
  ];
}
