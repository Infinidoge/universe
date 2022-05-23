{ config, lib, pkgs, ... }:
with lib;
with lib.hlissner;
{
  options = { };
  config = mkMerge [
    {
      networking.useDHCP = false;

      services.avahi = {
        enable = true;
        nssmdns = true;
        publish = {
          enable = true;
          userServices = true;
        };
        extraServiceFiles = {
          ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
        };
      };
    }
  ];
}
