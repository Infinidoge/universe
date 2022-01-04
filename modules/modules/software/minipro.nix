{ config, lib, pkgs, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.software.minipro;
in
{
  options.modules.software.minipro = {
    enable = mkBoolOpt false;
    udev = mkBoolOpt true;
  };
  config = mkIf cfg.enable {
    home.home.packages = with pkgs; [ minipro ];

    # https://gitlab.com/DavidGriffith/minipro/-/tree/master/udev
    services.udev.extraRules = mkIf cfg.udev ''
      ACTION!="add|change", GOTO="minipro_rules_end"
      SUBSYSTEM!="usb", GOTO="minipro_rules_end"

      # TL866A/CS
      ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="e11c", ENV{ID_MINIPRO}="1"

      # TL866II+
      ATTRS{idVendor}=="a466", ATTRS{idProduct}=="0a53", ENV{ID_MINIPRO}="1"

      LABEL="minipro_rules_end"

      ACTION!="add|change", GOTO="minipro_rules_plugdev_end"
      ENV{ID_MINIPRO}=="1", MODE="660", GROUP="plugdev"
      LABEL="minipro_rules_plugdev_end"

      ACTION!="add|change", GOTO="minipro_rules_uaccess_end"
      ENV{ID_MINIPRO}=="1", TAG+="uaccess"
      LABEL="minipro_rules_uaccess_end"
    '';
  };
}
