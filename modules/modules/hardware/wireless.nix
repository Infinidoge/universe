{ config, lib, private, pkgs, ... }:
with lib;
with lib.our;
let
  cfg = config.modules.hardware.wireless;
in
{
  imports = [ private.nixosModules.wireless ];

  options.modules.hardware.wireless = {
    enable = mkBoolOpt false;
    bluetooth = {
      enable = mkBoolOpt false;
      blueman.enable = mkBoolOpt true;
    };
    wifi.enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      modules.hardware.wireless = {
        bluetooth.enable = true;
        wifi.enable = true;
      };
    })
    (mkIf cfg.bluetooth.enable {
      hardware.bluetooth.enable = true;
      services.blueman.enable = cfg.bluetooth.blueman.enable;

      persist.directories = [
        "/var/lib/bluetooth"
      ];
    })
    (mkIf cfg.wifi.enable {
      networking.wireless = {
        enable = true;
        userControlled.enable = true;
        fallbackToWPA2 = mkDefault false;
      };
      environment.systemPackages = [ pkgs.wpa_supplicant_gui ];
    })
  ];
}
