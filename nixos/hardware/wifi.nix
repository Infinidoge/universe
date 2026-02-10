{ pkgs, private, ... }:
{
  networking.wireless = {
    enable = true;
    userControlled = true;
    fallbackToWPA2 = true;
  };

  environment.systemPackages = [ pkgs.wpa_supplicant_gui ];

  # WiFi passwords
  imports = [ private.nixosModules.wireless ];
}
