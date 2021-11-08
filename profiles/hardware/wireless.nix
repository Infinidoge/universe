{ ... }: {
  networking = {
    useDHCP = false;

    wireless = {
      enable = true;
      userControlled.enable = true;
    };
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
