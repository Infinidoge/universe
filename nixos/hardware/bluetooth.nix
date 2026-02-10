{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  persist.directories = [
    "/var/lib/bluetooth"
  ];
}
